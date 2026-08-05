# terraform-azurerm-caf-private_dns_zone

Manages an Azure Private DNS zone, its virtual network link(s), and (optionally) a
link to the core/hub virtual network — following the SSC Cloud Adoption Framework
(CAF) ESLZ module convention.

## Usage

### ESLZ module block (`ESLZ/private-dns-zone.tf`)

```hcl
module "private_dns_zone" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_dns_zone.git?ref=v1.1.0"
  for_each = var.privateDNSzone

  private_dns_zone = each.value
  name             = each.key
  resource_groups  = local.resource_groups_all
  vnet_id          = local.Project-vnet.id
  tags             = var.tags
}
```

### ESLZ tfvars pattern (`ESLZ/private-dns-zone.tfvars`)

```hcl
privateDNSzone = {
  "privatelink.blob.core.windows.net" = {   # Required: Key is the name of the private DNS zone
    resource_group = "DNS"                  # Optional: Can be the name or ID of a resource group. Default: DNS RG
    # vnet_link = ""                        # Optional: Uncomment and enter a VNET ID that you want to link to your DNS zone
    # registration_enabled = false          # Optional: Possible values: true, false. Default: false
    # resolution_policy = "Default"         # Optional: Possible values: Default, NxDomainRedirect. Default: Default
  }
}
```

## Testing

```bash
terraform fmt -recursive && terraform init -backend=false && terraform validate && terraform test
```

## CI

GitHub Actions workflow at `.github/workflows/terraform-ci.yml` runs fmt, init, validate, test, and tflint on every PR.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.dns-zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.core-zone-link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.dns-zone-link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Env part of the target subscription name | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the private DNS zone | `string` | n/a | yes |
| <a name="input_private_dns_zone"></a> [private\_dns\_zone](#input\_private\_dns\_zone) | (Required) Object describing the private DNS zone and the DNS zone link | `any` | `{}` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Objects containing all resource groups for the sub | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the Private DNS Zone | `map(string)` | `{}` | no |
| <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id) | (Required) Vnet ID to link to DNS zone to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_dns_zone"></a> [private\_dns\_zone](#output\_private\_dns\_zone) | Private DNS Zone object |
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | ID of Private DNS Zone |
| <a name="output_private_dns_zone_link"></a> [private\_dns\_zone\_link](#output\_private\_dns\_zone\_link) | Private DNS Zone link object |
| <a name="output_private_dns_zone_link_id"></a> [private\_dns\_zone\_link\_id](#output\_private\_dns\_zone\_link\_id) | ID of Private DNS Zone link |
| <a name="output_private_dns_zone_link_name"></a> [private\_dns\_zone\_link\_name](#output\_private\_dns\_zone\_link\_name) | Name of Private DNS Zone link |
| <a name="output_private_dns_zone_name"></a> [private\_dns\_zone\_name](#output\_private\_dns\_zone\_name) | Name of Private DNS Zone |
<!-- END_TF_DOCS -->

## TFVars Parameters

For more information about private dns zone parameters, refer to the terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link

| Name                                                                               | Possible values                                  | Default      | Required |
| ---------------------------------------------------------------------------------- | ------------------------------------------------ | ------------ | -------- |
| <a name="resource_group"></a> [resource_group](#resource\_group)                   | Name or ID of the resource group of the DNS zone | DNS-rg       | no       |
| <a name="vnet_link"></a> [vnet_link](#vnet\_link)                                  | ID of a VNET to link the DNS zone                | Project-vnet | no       |
| <a name="soa_record"></a> [soa_record](#soa\_record)                               | Block resource. SOA record for the DNS zone      | null         | no       |
| <a name="registration_enabled"></a> [registration_enabled](#registration\_enabled) | true, false                                      | false        | no       |
| <a name="resolution_policy"></a> [resolution_policy](#resolution\_policy)          | Default, NxDomainRedirect                        | Default      | no       |
| <a name="core_link_enabled"></a> [core_link_enabled](#core\_link\_enabled)         | true,false                                       | false        | no       |
