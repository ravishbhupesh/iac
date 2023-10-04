resource "aws_security_group" "allow_elasticache_traffic" {
  name        = "${var.name_prefix}-allow-elasticache-traffic"
  description = "Allow Elasticache traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = var.elasticache_input["redis_cluster_port"]
    to_port          = var.elasticache_input["redis_cluster_port"]
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_elasticache_subnet_group" "redis-cluster-subnet-grp" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.pub_subnet_ids
}

resource "aws_elasticache_cluster" "redisCluster" {
  cluster_id           = var.elasticache_input["replication_group_id"]
  engine               = var.elasticache_input["engine"]
  node_type            = var.elasticache_input["node_type"]
  num_cache_nodes      = var.elasticache_input["num_cache_nodes"]
  parameter_group_name = var.elasticache_input["parameter_group_name"]
  engine_version       = var.elasticache_input["engine_version"]
  port                 = var.elasticache_input["redis_cluster_port"]
  security_group_ids   = [aws_security_group.allow_elasticache_traffic.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis-cluster-subnet-grp.name
}