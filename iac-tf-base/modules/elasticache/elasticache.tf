resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.name_prefix}-cache-subnet"
  subnet_ids = ["${aws_subnet.default.*.id}"]
}

resource "aws_elasticache_replication_group" "default" {
  replication_group_id          = var.elasticache_input["cluster_id"]
  replication_group_description = var.elasticache_input["replication_group_description"]

  node_type            = var.elasticache_input["node_type"]
  port                 = var.elasticache_input["redis_clstr_port"]
  parameter_group_name = var.elasticache_input["parameter_group_name"]

  snapshot_retention_limit = var.elasticache_input["snapshot_retention_limit"]
  snapshot_window          = var.elasticache_input["snapshot_window"]

  subnet_group_name = aws_elasticache_subnet_group.default.name

  automatic_failover_enabled = var.elasticache_input["automatic_failover_enabled"]

  cluster_mode {
    replicas_per_node_group = var.elasticache_input["replicas_per_node_group"]
    num_node_groups         = var.elasticache_input["num_node_groups"]
  }
}                                                                  