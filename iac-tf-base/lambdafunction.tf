module "lambdafunction" {
  source = "./modules/lambdafunction"

  vpc_id         = local.network_input["vpc_id"]
  pub_subnet_ids = local.network_input["pub_subnet_ids"]
  common_tags    = local.common_tags
  name_prefix    = local.name_prefix
  redis_endpoint = module.elasticache.redis_cluster_endpoint
  redis_url      = module.elasticache.redis_cluster_endpoint_host
  redis_port     = module.elasticache.redis_cluster_endpoint_port
  sg_id          = module.elasticache.cache_security_group_id

  lambda_payload_filename = "../pointcode-app/target/pointcode-app-0.0.1.jar"
}