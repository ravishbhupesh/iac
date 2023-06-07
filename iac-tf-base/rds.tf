module "rds" {
  source = "./modules/rds"

  v_vpc_id          = module.vpc.vpc_id
  v_private_subnets = module.vpc.private_subnets
  common_tags       = local.common_tags
  name_prefix       = local.name_prefix
  rds_input         = local.rds_input
}