variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "pub_subnet_ids" {
  type        = list(string)
  description = "List of public subnets available in given vpc"
  default     = []
}

variable "pvt_subnet_ids" {
  type        = list(string)
  description = "List of private subnets available in given vpc"
  default     = []
}

variable "name_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "iac"
}

variable "elasticache_input" {
  type        = map(string)
  description = "Map of input values for elasticache module"
  default     = {}
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}