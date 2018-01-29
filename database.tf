module "db_security_group" {
  source = "github.com/rastandy/terraform-aws-security-group?ref=v1.13.0"

  name        = "${var.service}-${terraform.workspace}-db-security-group"
  description = "Security group for ${var.service} usage with the wiki Database"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["${module.vpc.public_subnets_cidr_blocks}"]
  ingress_rules       = ["postgresql-tcp"]
}

module "db" {
  source = "github.com/rastandy/terraform-aws-rds?ref=v1.8.0"

  identifier = "${var.service}-${terraform.workspace}-database"

  engine            = "postgres"
  engine_version    = "9.6.3"
  instance_class    = "${var.db_instance_type}"
  allocated_storage = 5
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<accound id>:key/<kms key id>"
  name = "${var.db_user}"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "${var.db_user}"

  password = "${var.db_password}"

  port = "${var.db_port}"

  vpc_security_group_ids = ["${module.db_security_group.this_security_group_id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 7

  tags = {
    Owner       = "CMCC"
    Project     = "${var.project}"
    Serivce     = "${var.service}"
    Environment = "${terraform.workspace}"
  }

  # DB subnet group
  subnet_ids = ["${module.vpc.database_subnets}"]

  # DB parameter group
  family = "postgres9.6"

  skip_final_snapshot = false

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.service}-database"
}
