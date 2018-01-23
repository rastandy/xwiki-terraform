provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.service}-remote-state"
    key    = "env:/${terraform.workspace}/vpc/terraform.tfstate"
    region = "${var.aws_region}"
  }
}

module "security_group" {
  source = "github.com/rastandy/terraform-aws-security-group?ref=1.13.0"

  name        = "${var.service}-security-group"
  description = "Security group for ${var.service} usage with EC2 instance"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "http-8080-tcp", "http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

data "aws_ami" "centos_7" {
  most_recent = true

  owners = ["679593333241"]

  filter {
    name = "name"

    values = [
      "CentOS Linux 7 x86_64 HVM EBS*",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "aws-marketplace",
    ]
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "${var.service}-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCom3uwiMB266XmVvBu9wHaQf8VQyPDhBBiwOHBEiDU1mo258dqmRaGNslHZ09pbvLhqdkJL9JveHbJJq4vHSdjPQCxXvp2O+4UcokFewNkKOz+IssLWyYV+3HmFWy4n6KMkpEsGLu6JW8z3j1xMibu8Z7JquMC8Im+TenjpEfhaED5Zuo8I1E7QgmNnoX62dD3hrz70Je1t7yiSuOVoyqEX4bylvasMQOLamKfcSahLfr17o8hgHNcLnXwTc//rgK1vukVBpYIjyUmXpiAlKqPRRYTB6f8tAeOn3Mt4Be4+9pQG5RqCy0SzaGkDqLaxtwZ2eZ/AJYK8PzXuUyQ2lqZ arusso@Andrea-Mac.local"
}

module "ec2_cluster" {
  source = "github.com/rastandy/terraform-aws-ec2-instance?ref=v1.2.0"

  name  = "xwiki-instance-${terraform.workspace}"
  count = 1

  ami                    = "${data.aws_ami.centos_7.image_id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.keypair.key_name}"
  monitoring             = true
  vpc_security_group_ids = ["${module.security_group.this_security_group_id}"]
  subnet_id              = "${data.terraform_remote_state.vpc.public_subnets.0}"

  tags = {
    Environment = "${terraform.workspace}"
    Service     = "${var.service}"
  }
}
