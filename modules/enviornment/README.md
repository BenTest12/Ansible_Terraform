<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_weight_app_vmss"></a> [weight\_app\_vmss](#module\_weight\_app\_vmss) | ../modules/VMSS | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.app_load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.bepool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_nat_pool.lbnatpool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_pool) | resource |
| [azurerm_lb_probe.app_lb_probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.lb_rule_8080_IN](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_network_security_group.db_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.weight_app_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_postgresql_flexible_server.postgres_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_configuration.db-config-no-ssl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_private_dns_zone.private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.project_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.project_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_ssh_public_key.my_private_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ssh_public_key) | resource |
| [azurerm_subnet.app-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.db-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.app_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.db_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.project_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

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
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_rg_prefix"></a> [rg\_prefix](#input\_rg\_prefix) | Resource group name prefix | `string` | n/a | yes |
| <a name="input_vnet_address_range"></a> [vnet\_address\_range](#input\_vnet\_address\_range) | VNET IP Address Range | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->