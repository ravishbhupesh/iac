output "redis_cluster_endpoint_host" {
  value = aws_elasticache_cluster.redisCluster.cache_nodes.0.address
}

output "redis_cluster_endpoint_port" {
  value = aws_elasticache_cluster.redisCluster.cache_nodes.0.port
}

output "redis_cluster_endpoint" {
  value = join(":", tolist([aws_elasticache_cluster.redisCluster.cache_nodes.0.address, aws_elasticache_cluster.redisCluster.cache_nodes.0.port]))
}

output "cache_security_group_id" {
  value = aws_security_group.redis_sg.id
}
