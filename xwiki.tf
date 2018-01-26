# Image: Ubuntu server 16.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "${var.service}-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCom3uwiMB266XmVvBu9wHaQf8VQyPDhBBiwOHBEiDU1mo258dqmRaGNslHZ09pbvLhqdkJL9JveHbJJq4vHSdjPQCxXvp2O+4UcokFewNkKOz+IssLWyYV+3HmFWy4n6KMkpEsGLu6JW8z3j1xMibu8Z7JquMC8Im+TenjpEfhaED5Zuo8I1E7QgmNnoX62dD3hrz70Je1t7yiSuOVoyqEX4bylvasMQOLamKfcSahLfr17o8hgHNcLnXwTc//rgK1vukVBpYIjyUmXpiAlKqPRRYTB6f8tAeOn3Mt4Be4+9pQG5RqCy0SzaGkDqLaxtwZ2eZ/AJYK8PzXuUyQ2lqZ arusso@Andrea-Mac.local"
}

module "security_group" {
  source = "github.com/rastandy/terraform-aws-security-group?ref=v1.13.0"

  name        = "${var.service}-security-group"
  description = "Security group for ${var.service} usage with EC2 instance"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "https-443-tcp", "http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "ec2_cluster" {
  source = "github.com/rastandy/terraform-aws-ec2-instance?ref=v1.2.0"

  name  = "xwiki-instance-${terraform.workspace}"
  count = 1

  ami                         = "${data.aws_ami.ubuntu.image_id}"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.keypair.key_name}"
  monitoring                  = false
  vpc_security_group_ids      = ["${module.security_group.this_security_group_id}"]
  subnet_id                   = "${module.vpc.public_subnets[0]}"
  associate_public_ip_address = true

  # ebs_optimized               = true

  tags = {
    Environment = "${terraform.workspace}"
    Service     = "${var.service}"
  }
}

resource "aws_eip" "xwiki_eip" {
  instance = "${module.ec2_cluster.id[0]}"
  vpc      = true
}