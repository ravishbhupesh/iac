resource "aws_security_group" "rds-sg" {
  name   = "${var.name_prefix}-rds-sg"
  vpc_id = var.v_vpc_id

  ingress {
    from_port   = var.rds_db_port
    to_port     = var.rds_db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.rds_db_port
    to_port     = var.rds_db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "aws_db_subnet_group" "rds-sbnt-gp" {
  name       = "${var.name_prefix}-rds-sbnt-gp"
  subnet_ids = var.v_private_subnets

  tags = var.common_tags
}

resource "aws_db_parameter_group" "rds-db-pg" {
  name   = "${var.name_prefix}-rds-db-pg"
  family = var.rds_db_family

  parameter {
    name  = "log_connections"
    value = "1"
  }

  tags = var.common_tags
}

resource "aws_db_instance" "rds-db-inst" {
  identifier             = var.rds_db_identifier
  instance_class         = var.rds_db_instance_class
  allocated_storage      = 5
  engine                 = var.rds_db_engine
  engine_version         = var.rds_db_engine_version
  username               = var.rds_db_username
  password               = var.rds_db_password
  db_subnet_group_name   = aws_db_subnet_group.rds-sbnt-gp.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = aws_db_parameter_group.rds-db-pg.name
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot

  tags = var.common_tags
}