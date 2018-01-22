provider "aws" {
  region = "${var.aws_region}"
}

module "remote_state" {
  source      = "github.com/rastandy/tf_remote_state?ref=0.1.1"

  region = "${var.aws_region}"
  prefix = "${var.remote_state_prefix}"
}
