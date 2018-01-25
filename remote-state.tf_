## S3 Backed terraform state with DynamoDB locking.

module "remote_state" {
  source = "github.com/rastandy/tf_remote_state?ref=0.1.1"

  region = "${var.aws_region}"
  prefix = "cmcc-${var.service}"
}
