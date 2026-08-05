mock_provider "azurerm" {}

variables {
  name = "privatelink.blob.core.windows.net"
  resource_groups = {
    DNS = {
      name     = "GcPc-CTO-ENT-CORE-Dns-rg"
      location = "canadacentral"
    }
  }
  vnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/GcPc-CTO-ENT-CORE-Network-rg/providers/Microsoft.Network/virtualNetworks/GcPcCNR-Project-vnet"
  tags    = { environment = "test" }
}

# Step 1: simulate a currently-deployed resource using pre-upgrade-style inputs
# (no resolution_policy — argument didn't exist in the caller's tfvars before this upgrade)
run "baseline_apply" {
  command = apply

  variables {
    private_dns_zone = {
      resource_group = "DNS"
    }
  }

  override_resource {
    target = azurerm_private_dns_zone.dns-zone
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/GcPc-CTO-ENT-CORE-Dns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    }
  }

  assert {
    condition     = azurerm_private_dns_zone.dns-zone.name == "privatelink.blob.core.windows.net"
    error_message = "Baseline apply: unexpected private DNS zone name"
  }
  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.private_dns_zone_id == azurerm_private_dns_zone.dns-zone.id
    error_message = "Baseline apply: vnet link must reference the zone by ID"
  }
}

# Step 2: plan the upgraded code against that state, adding the new optional argument
run "upgrade_plan_no_replacement" {
  command = plan

  variables {
    private_dns_zone = {
      resource_group    = "DNS"
      resolution_policy = "Default"
    }
  }

  assert {
    condition     = azurerm_private_dns_zone.dns-zone.name == "privatelink.blob.core.windows.net"
    error_message = "Zone name must be unchanged after upgrade"
  }
  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.name == "privatelink.blob.core.windows.net-vlnk"
    error_message = "Vnet link name must be unchanged after upgrade"
  }
  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.resolution_policy == "Default"
    error_message = "resolution_policy must be settable post-upgrade"
  }
}
