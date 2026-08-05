output "private_dns_zone_name" {
  description = "Name of Private DNS Zone"
  value       = azurerm_private_dns_zone.dns-zone.name
}

output "private_dns_zone_id" {
  description = "ID of Private DNS Zone"
  value       = azurerm_private_dns_zone.dns-zone.id
}

output "private_dns_zone" {
  description = "Private DNS Zone object"
  value       = azurerm_private_dns_zone.dns-zone
}

output "private_dns_zone_link_name" {
  description = "Name of Private DNS Zone link"
  value       = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.name
}

output "private_dns_zone_link_id" {
  description = "ID of Private DNS Zone link"
  value       = azurerm_private_dns_zone_virtual_network_link.dns-zone-link.id
}

output "private_dns_zone_link" {
  description = "Private DNS Zone link object"
  value       = azurerm_private_dns_zone_virtual_network_link.dns-zone-link
}
