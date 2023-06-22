locals {

  input = jsondecode(file("./input-template.json"))

  project = lookup(local.input, "project")
  company = lookup(local.input, "company")

  aws_region  = lookup(local.input, "aws_region")
  name_prefix = lookup(local.input, "naming_prefix")
  envVal      = lookup(local.input, "environment")

  common_tags = {
    company     = local.company
    project     = "${local.company}-${local.project}"
    environment = local.envVal
  }

  rds_input = local.input["rds"]

  #common_tags = {
  #  company     = var.company
  #  project     = "${var.company}-${var.project}"
  #  environment = terraform.workspace
  #}
}