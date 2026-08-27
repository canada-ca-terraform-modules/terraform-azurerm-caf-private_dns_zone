terraform {
  required_version = ">= 1.9"
  # live-test workflow: .github/workflows/live-test.yml
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }

  # Empty on purpose: the state file path is supplied at `terraform init`
  # time via `-backend-config="path=..."` (partial configuration), so the
  # target-branch checkout and the PR-branch checkout can point at the same
  # external state file without either owning its own local state.
  backend "local" {}
}

provider "azurerm" {
  storage_use_azuread             = true
  resource_provider_registrations = "legacy"
  features {
    resource_group {
      # This harness's resource group is fully self-owned by Terraform - no
      # risk of destroying anything not created by this run.
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "private_dns_zone" {
  # PR code and baseline code are two on-disk checkouts of this same repo,
  # not two resolved git refs - no pinned ?ref, no version toggle here.
  source = "../../"

  name             = var.zone_name
  env              = var.env
  resource_groups  = local.resource_groups # from test_dependencies.tf
  vnet_id          = local.vnet_id         # from test_dependencies.tf
  tags             = var.tags
  private_dns_zone = var.private_dns_zone
}
