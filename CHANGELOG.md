# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## v1.1.0 - 2026-08-05

### Changed

- Upgraded to azurerm provider `~> 5.0` (target: v5.0.1).
- Fixed `azurerm_private_dns_zone_virtual_network_link.private_dns_zone_name` — this
  argument no longer exists in the azurerm provider schema (only `private_dns_zone_id`
  is supported). Both `dns-zone-link` and `core-zone-link` now reference the zone by
  `azurerm_private_dns_zone.dns-zone.id`. No plan-time value change, no resource
  replacement.
- Fixed invalid regex escape sequence in `locals.tf` (`[^\/]+$` -> `[^/]+$`) — `\/`
  is not a valid RE2 escape sequence.

### Added

- `resolution_policy` (optional) on both virtual network link resources —
  new azurerm provider argument, wired through `var.private_dns_zone.resolution_policy`
  with `try(..., null)` so existing tfvars are unaffected.
- `providers.tf` pinning `azurerm ~> 5.0` and `required_version >= 1.9`.
- `.tflint.hcl` with the `azurerm` ruleset plugin.
- `tests/private_dns_zone.tftest.hcl` and `tests/upgrade_compat.tftest.hcl` —
  full mock_provider test coverage (naming, resource group by name/ID, vnet
  link override, registration_enabled, resolution_policy, soa_record,
  core_link_enabled, and a state-chaining upgrade-safety test).
- `.gitignore`, `.gitattributes` (LF enforcement).
- `.github/workflows/terraform-ci.yml`, `documentation.yml`, `release.yml`.

### Known blockers

- None.
