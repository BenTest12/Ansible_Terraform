<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.12 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>2.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_enviornment"></a> [enviornment](#module\_enviornment) | ../modules/enviornment | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Ubuntu machine administrator password | `string` | n/a | yes |
| <a name="input_admin_user"></a> [admin\_user](#input\_admin\_user) | Ubuntu machine administrator user | `string` | n/a | yes |
| <a name="input_app_subnet_address_range"></a> [app\_subnet\_address\_range](#input\_app\_subnet\_address\_range) | Application Subnet Range | `string` | n/a | yes |
| <a name="input_db_address_range"></a> [db\_address\_range](#input\_db\_address\_range) | DB Subnet Range | `string` | n/a | yes |
| <a name="input_my_ip"></a> [my\_ip](#input\_my\_ip) | My WAN Address , used to access the vmss via ssh | `string` | n/a | yes |
| <a name="input_postgres_admin_username"></a> [postgres\_admin\_username](#input\_postgres\_admin\_username) | PostgreSQL DB administrator username | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL DB administrator password | `string` | n/a | yes |
| <a name="input_postgres_sku_name"></a> [postgres\_sku\_name](#input\_postgres\_sku\_name) | PostgreSQL DB server SKU | `string` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | My personal public key , used to access the vmss via ssh | `string` | n/a | yes |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | Location of the resource group | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Map with two different name for a group | `map` | <pre>{<br>  "production": "production",<br>  "staging": "staging"<br>}</pre> | no |
| <a name="input_rg_prefix"></a> [rg\_prefix](#input\_rg\_prefix) | Resource group name prefix | `string` | n/a | yes |
| <a name="input_vnet_address_range"></a> [vnet\_address\_range](#input\_vnet\_address\_range) | VNET IP Address Range | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->