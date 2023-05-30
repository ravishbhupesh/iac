variable "v_vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "v_private_subnets" {
  type        = list(string)
  description = "RDS database identifier"
}

variable "name_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "iac"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}

variable "rds_db_identifier" {
  type        = string
  description = "RDS database identifier"
  default     = "defaultidt"
}

variable "rds_db_username" {
  type        = string
  description = "RDS database username"
  default     = "defaultuser"
}

variable "rds_db_password" {
  type        = string
  description = "RDS database username"
  default     = "defaultpassword"
}

variable "rds_db_port" {
  type        = number
  description = "RDS database port"
  default     = 5432
}

variable "rds_db_family" {
  type        = string
  description = "RDS database family"
  default     = "postgres14"
}

variable "rds_db_instance_class" {
  type        = string
  description = "RDS database Instance Class"
  default     = "db.t3.micro"
}

variable "rds_db_engine" {
  type        = string
  description = "RDS database engine"
  default     = "postgres"
}

variable "rds_db_engine_version" {
  type        = string
  description = "RDS database engine version"
  default     = "14.1"
}

variable "publicly_accessible" {
  type        = bool
  description = "Should this RDS be publically accessible"
  default     = false
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Should a final snapshot be taken for the RDS while destroying"
  default     = false
}