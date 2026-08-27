# test_dependencies.tf
# Self-contained dependency resources, owned entirely by this harness.
#
# Deliberately NOT reusing any shared/production resource group: writing into
# a shared RG usually requires elevated, non-sandbox permissions. A dedicated
# throwaway RG here needs only Contributor on the sandbox subscription and
# can never collide with or affect any production resource.
#
# terraform-azurerm-caf-private_dns_zone needs:
#   - a resource_groups map (keyed the same way the module's
#     "resource_group" tfvars field references it)
#   - a vnet_id string to link the DNS zone to

resource "azurerm_resource_group" "live_test" {
  # PR-number suffix keeps two concurrently open PRs against this module from
  # colliding on the same sandbox resource group.
  name     = "${var.env}-caf-private-dns-zone-live-test-${var.pr_number}-rg"
  location = var.location

  # pr-number tag (ticket 13): lets the nightly orphan sweeper find this RG
  # by tag and match it back to a PR, independent of naming convention.
  tags = {
    "pr-number" = var.pr_number
  }
}

resource "azurerm_virtual_network" "live_test" {
  name                = "${var.env}-caf-private-dns-zone-live-test-${var.pr_number}-vnet"
  address_space       = ["10.252.0.0/16"]
  location            = azurerm_resource_group.live_test.location
  resource_group_name = azurerm_resource_group.live_test.name
}

locals {
  # terraform-azurerm-caf-private_dns_zone expects resource_groups as a
  # purpose-keyed map where each value has at least .name - the tfvars
  # fixture references the "DNS" key.
  resource_groups = {
    DNS = { name = azurerm_resource_group.live_test.name }
  }

  vnet_id = azurerm_virtual_network.live_test.id
}
