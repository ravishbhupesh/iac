resource "aws_security_group" "rds-sg" {
  name   = "${var.name_prefix}-rds-sg"
  vpc_id = var.v_vpc_id

  ingress {
    from_port   = var.rds_input["rds_db_port"]
    to_port     = var.rds_input["rds_db_port"]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.rds_input["rds_db_port"]
    to_port     = var.rds_input["rds_db_port"]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "random_password" "rds_master_pswd" {
  length           = 30
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "rds_scrt" {
  name        = "${var.name_prefix}-rds-scrt"
  description = "${var.name_prefix} Secret for storing RDS master password"

  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "rds_scrt_val" {
  secret_id = aws_secretsmanager_secret.rds_scrt.id
  secret_string = random_password.rds_master_pswd.result
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier        = var.rds_input["rds_db_identifier"]
  allocated_storage = var.rds_input["rds_allocated_storage"]

  engine         = var.rds_input["rds_db_engine"]
  engine_version = var.rds_input["rds_db_engine_version"]
  instance_class = var.rds_input["rds_db_instance_class"]


  db_name  = var.rds_input["rds_db_name"]
  username = var.rds_input["rds_db_username"]
  port     = var.rds_input["rds_db_port"]

  create_random_password = var.rds_input["rds_create_random_password"]
  password = aws_secretsmanager_secret_version.rds_scrt_val.secret_id

  #iam_database_authentication_enabled = true

  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  # Logging
  cloudwatch_log_group_retention_in_days = var.rds_input["rds_cloudwatch_log_group_retention_in_days"]

  # Backup & Maintainence
  maintenance_window      = var.rds_input["rds_maintenance_window"]
  backup_window           = var.rds_input["rds_backup_window"]
  backup_retention_period = var.rds_input["backup_retention_period"]

  # Monitoring
  create_monitoring_role = var.rds_input["rds_create_monitoring_role"]
  monitoring_role_name   = "${var.name_prefix}-rds-monitoring-role"
  monitoring_interval    = var.rds_input["rds_aws_monitoring_interval"]

  # DB subnet group
  create_db_subnet_group = var.rds_input["rds_create_db_subnet_group"]
  db_subnet_group_name   = "${var.name_prefix}-sbnt-grp-nm"
  subnet_ids             = var.v_private_subnets

  # DB parameter group
  family = var.rds_input["rds_db_family"]

  publicly_accessible = var.rds_input["rds_publicly_accessible"]

  # DB option group
  major_engine_version = var.rds_input["rds_db_engine_version"]

  # Database Deletion Protection
  deletion_protection = var.rds_input["rds_aws_deletion_protection"]

  # Performance Insights
  performance_insights_enabled          = var.rds_input["rds_aws_performance_insights_enabled"]
  performance_insights_retention_period = var.rds_input["rds_aws_performance_insights_retention_period"]

  tags = var.common_tags
}