locals {
  # We might receive an RG name or ID. If the variable contains /resourceGroups/ then we recieved an ID and we take everything after the last / with the regex
  # If not we have the name and we can get the full name with the resource group object provided by ESLZ
  # Both variables are optional, so we need to wrap it with a try in case they are not set. In that case we use defaults
  resource_group_name = try(strcontains(var.private_dns_zone.resource_group, "/resourceGroups/") ? regex("[^/]+$", var.private_dns_zone.resource_group) : var.resource_groups[var.private_dns_zone.resource_group].name, "")

  # If we received an ID, then we take it as is. If we didn't, then we take the default vnet ID of the sub of the project
  vnet_id = try(strcontains(var.private_dns_zone.vnet_link, "/resourceGroups/") ? var.private_dns_zone.vnet_link : var.vnet_id, var.vnet_id)

  core_vnet_id = length(regexall("^.3..$", var.env)) > 0 ? "/subscriptions/93aef9d8-f8cf-4d9f-9e07-5373f3d722c2/resourceGroups/G3Mc-CTO-ENT-MRZ-Network-rg/providers/Microsoft.Network/virtualNetworks/G3McCNR-MRZ-vnet" : "/subscriptions/c8e75926-9169-46ba-9af1-8c657141280e/resourceGroups/GcPc-CTO-ENT-CORE-Network-rg/providers/Microsoft.Network/virtualNetworks/GcPcCNR-MRZ-vnet"
}
