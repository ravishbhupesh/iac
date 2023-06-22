##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  cidr            = var.vpc_cidr_block[var.envVal]
  azs             = slice(data.aws_availability_zones.available.names, 0, (var.vpc_subnet_count[var.envVal]))
  public_subnets  = [for subnet in range(var.vpc_subnet_count[var.envVal]) : cidrsubnet(var.vpc_cidr_block[var.envVal], 8, subnet)]
  private_subnets = [for subnet in range(var.vpc_subnet_count[var.envVal]) : cidrsubnet(var.vpc_cidr_block[var.envVal], 8, subnet + 3)]

  enable_nat_gateway      = false
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })

}