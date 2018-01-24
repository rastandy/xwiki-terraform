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

resource "aws_db_instance" "db" {
  engine               = "postgres"
  allocated_storage    = 5
  instance_class       = "db.t2.micro"
  name                 = "${var.db_user}"
  username             = "${var.db_user}"
  password             = "${var.db_password}"
  db_subnet_group_name = "${data.terraform_remote_state.vpc.database_subnet_group}"
}
