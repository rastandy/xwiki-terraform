# Availabilty zones in the configured AWS region
data "aws_availability_zones" "azs" {}

module "vpc" {
  source = "github.com/rastandy/terraform-aws-vpc?ref=v1.17.0"

  name = "${var.project}-${var.service}-vpc-${terraform.workspace}"

  cidr = "10.0.0.0/16"

  azs              = ["${data.aws_availability_zones.azs.names}"]
  private_subnets  = ["10.0.1.0/24"]
  public_subnets   = ["10.0.101.0/24"]
  database_subnets = ["10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = false

  tags = "${merge("${var.tags}", map("Environment", "${terraform.workspace}", "Project", "${var.project}", "Service", "${var.service}"))}"
}
