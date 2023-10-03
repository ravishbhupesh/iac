variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "iac"
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "eu-west-1"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "Infosys"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "iac-template"
}

variable "envVal" {
  type        = string
  description = "environment to built"
  default     = "dev"
}
