variable "name_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "iac"
}

variable "redis_endpoint" {
  type        = string
  description = "Endpoint of redis cluster with port"
}

variable "redis_url" {
  type        = string
  description = "Endpoint of redis cluster"
}

variable "redis_port" {
  type        = string
  description = "Port of redis cluster"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}

variable "lambda_payload_filename" {
  type        = string
  description = "Loation of jar file for lambda"
}

variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "pub_subnet_ids" {
  type        = list(string)
  description = "List of public subnets available in given vpc"
  default     = []
}

variable "sg_id" {
  type        = string
  description = "security groups"
}