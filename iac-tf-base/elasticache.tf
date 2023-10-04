module "elasticache" {
  source = "./modules/elasticache"

  vpc_id            = local.network_input["vpc_id"]
  pub_subnet_ids    = local.network_input["pub_subnet_ids"]
  pvt_subnet_ids    = local.network_input["pvt_subnet_ids"]
  common_tags       = local.common_tags
  name_prefix       = local.name_prefix
  elasticache_input = local.elasticache_input
}