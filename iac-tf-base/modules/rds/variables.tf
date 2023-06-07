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

variable "rds_input" {
  type        = map(string)
  description = "Map of input values for rds module"
  default     = {}
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}
