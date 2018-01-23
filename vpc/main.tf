provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = "github.com/rastandy/terraform-aws-vpc?ref=v1.17.0"

  name = "eucp-vpc-${terraform.workspace}"

  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project     = "EUCP"
    Service     = "${var.service}"
    Environment = "${terraform.workspace}"
  }
}
