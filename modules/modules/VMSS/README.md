<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine_scale_set.weight_app_vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_monitor_autoscale_setting.autoscale_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | n/a | `string` | n/a | yes |
| <a name="input_admin_user"></a> [admin\_user](#input\_admin\_user) | n/a | `string` | n/a | yes |
| <a name="input_lb_bepool_id"></a> [lb\_bepool\_id](#input\_lb\_bepool\_id) | n/a | `string` | n/a | yes |
| <a name="input_lbnatpool_id"></a> [lbnatpool\_id](#input\_lbnatpool\_id) | n/a | `string` | n/a | yes |
| <a name="input_number_of_instances"></a> [number\_of\_instances](#input\_number\_of\_instances) | n/a | `number` | `2` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | n/a | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_weight_app_name_prefix"></a> [weight\_app\_name\_prefix](#input\_weight\_app\_name\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_weight_app_nsg_id"></a> [weight\_app\_nsg\_id](#input\_weight\_app\_nsg\_id) | n/a | `string` | n/a | yes |
| <a name="input_weight_app_subnet_id"></a> [weight\_app\_subnet\_id](#input\_weight\_app\_subnet\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->