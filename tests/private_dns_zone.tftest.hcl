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

run "default_values" {
  command = plan

  variables {
    private_dns_zone = {
      resource_group = "DNS"
    }
  }

  assert {
    condition     = azurerm_private_dns_zone.dns-zone.name == "privatelink.blob.core.windows.net"
    error_message = "Private DNS zone name must match var.name"
  }
  assert {
    condition     = azurerm_private_dns_zone.dns-zone.resource_group_name == "GcPc-CTO-ENT-CORE-Dns-rg"
    error_message = "Resource group must resolve from resource_groups map when a name is supplied"
  }
  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.name == "privatelink.blob.core.windows.net-vlnk"
    error_message = "Vnet link name must follow {name}-vlnk convention"
  }
  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.virtual_network_id == var.vnet_id
    error_message = "Vnet link must default to var.vnet_id when vnet_link is not supplied"
  }
  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.registration_enabled == false
    error_message = "registration_enabled must default to false"
  }
  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.core-zone-link) == 0
    error_message = "core-zone-link must not be created when core_link_enabled is not set"
  }
}

run "resource_group_by_id" {
  command = plan

  variables {
    private_dns_zone = {
      resource_group = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/GcPc-Custom-Dns-rg"
    }
  }

  assert {
    condition     = azurerm_private_dns_zone.dns-zone.resource_group_name == "GcPc-Custom-Dns-rg"
    error_message = "Resource group must be extracted from a resource group ID when one is supplied"
  }
}

run "vnet_link_override" {
  command = plan

  variables {
    private_dns_zone = {
      resource_group = "DNS"
      vnet_link      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/GcPc-Custom-rg/providers/Microsoft.Network/virtualNetworks/custom-vnet"
    }
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.virtual_network_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/GcPc-Custom-rg/providers/Microsoft.Network/virtualNetworks/custom-vnet"
    error_message = "vnet_link override must be used as-is when it is a resource ID"
  }
}

run "registration_enabled" {
  command = plan

  variables {
    private_dns_zone = {
      resource_group       = "DNS"
      registration_enabled = true
    }
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.registration_enabled == true
    error_message = "registration_enabled must be passed through when set"
  }
}

run "resolution_policy" {
  command = plan

  variables {
    private_dns_zone = {
      resource_group    = "DNS"
      resolution_policy = "NxDomainRedirect"
    }
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.resolution_policy == "NxDomainRedirect"
    error_message = "resolution_policy must be passed through when set"
  }
}

run "soa_record_custom" {
  command = plan

  variables {
    private_dns_zone = {
      resource_group = "DNS"
      soa_record = {
        email        = "azurecloudoperations.operationsinfonuagiquesazure_ssc-spc.gc.ca"
        expire_time  = 1209600
        minimum_ttl  = 60
        refresh_time = 7200
        retry_time   = 600
        ttl          = 7200
      }
    }
  }

  assert {
    condition     = azurerm_private_dns_zone.dns-zone.soa_record[0].email == "azurecloudoperations.operationsinfonuagiquesazure_ssc-spc.gc.ca"
    error_message = "soa_record.email override not applied"
  }
  assert {
    condition     = azurerm_private_dns_zone.dns-zone.soa_record[0].expire_time == 1209600
    error_message = "soa_record.expire_time override not applied"
  }
}

run "core_link_enabled" {
  command = plan

  variables {
    private_dns_zone = {
      resource_group    = "DNS"
      core_link_enabled = true
    }
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.core-zone-link) == 1
    error_message = "core-zone-link must be created when core_link_enabled is true"
  }
  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.core-zone-link[0].name == "privatelink.blob.core.windows.net-core-vlnk"
    error_message = "core-zone-link name must follow {name}-core-vlnk convention"
  }
}
