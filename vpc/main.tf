provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = "github.com/rastandy/terraform-aws-vpc?ref=v1.17.0"

  name = "eucp-vpc-${terraform.workspace}"

  cidr = "10.0.0.0/16"

  azs              = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets  = ["10.0.1.0/24"]
  public_subnets   = ["10.0.101.0/24"]
  database_subnets = ["10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = false

  tags = {
    Project     = "EUCP"
    Service     = "${var.service}"
    Environment = "${terraform.workspace}"
  }
}
