module "enviornment" {
  source                   = "../modules/enviornment"
  for_each                 = var.rg_name
  rg_name                  = each.value
  rg_prefix                = var.rg_prefix
  rg_location              = var.rg_location
  vnet_address_range       = var.vnet_address_range
  app_subnet_address_range = var.app_subnet_address_range
  db_address_range         = var.db_address_range
  my_ip                    = var.my_ip
  project_key              = var.project_key
  admin_user               = var.admin_user
  admin_password           = var.admin_password
  postgres_admin_username  = var.postgres_admin_username
  postgres_password        = var.postgres_password
  postgres_sku_name        = var.postgres_sku_name
}

