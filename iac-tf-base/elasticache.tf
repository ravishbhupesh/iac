module "elasticache" {
  source = "./modules/elasticache"

  v_vpc_id          = module.vpc.vpc_id
  common_tags       = local.common_tags
  name_prefix       = local.name_prefix
  elasticache_input = local.elasticache_input
}