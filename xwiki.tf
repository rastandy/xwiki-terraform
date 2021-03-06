# Image: XWiki CMCC on Ubuntu server 16.04 LTS
# data "aws_ami" "xwiki_image" {
#   most_recent = true
#   owners      = ["719747043315"]

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   filter {
#     name   = "image-type"
#     values = ["machine"]
#   }

#   filter {
#     name   = "name"
#     values = ["XWiki ${var.xwiki_version}*"]
#   }
# }

resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.service}-${terraform.workspace}-key-pair"
  public_key = "${file(var.ec2_key_file)}"
}

module "security_group" {
  source = "github.com/rastandy/terraform-aws-security-group?ref=v1.13.0"

  name        = "${var.project}-${var.service}-${terraform.workspace}-security-group"
  description = "Security group for ${var.service} usage with EC2 instance"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "https-443-tcp", "http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = "${merge("${var.tags}", map("Environment", "${terraform.workspace}", "Project", "${var.project}", "Service", "${var.service}"))}"
}

resource "aws_instance" "xwiki_instance" {
  count = 1

  # ami                    = "${data.aws_ami.xwiki_image.image_id}"
  ami                    = "${var.xwiki_ami}"
  instance_type          = "${var.ec2_instance_type}"
  key_name               = "${aws_key_pair.keypair.key_name}"
  monitoring             = false
  vpc_security_group_ids = ["${module.security_group.this_security_group_id}"]
  subnet_id              = "${module.vpc.public_subnets[0]}"
  availability_zone      = "${data.aws_availability_zones.azs.names[0]}"

  # ebs_optimized               = true

  tags = "${merge("${var.tags}", map("Environment", "${terraform.workspace}", "Project", "${var.project}", "Service", "${var.service}", "Name", "${var.project}-${var.service}-${terraform.workspace}"))}"
}

resource "aws_volume_attachment" "xwiki_permanent_data_attachment" {
  device_name = "${var.xwiki_permanent_dir_volume_block_device}"
  volume_id   = "${aws_ebs_volume.xwiki_permanent_data.id}"
  instance_id = "${aws_instance.xwiki_instance.id}"
}

resource "aws_ebs_volume" "xwiki_permanent_data" {
  availability_zone = "${aws_instance.xwiki_instance.availability_zone}"
  size              = "${var.xwiki_permanent_directory_volume_size}"
  type              = "gp2"
  snapshot_id       = "${var.xwiki_permanent_directory_snapshot_id}"

  tags = "${merge("${var.tags}", map("Environment", "${terraform.workspace}", "Project", "${var.project}", "Service", "${var.service}", "Name", "${var.project}-${var.service}-${terraform.workspace}-permanent-data-volume"))}"
}

resource "aws_eip" "xwiki_eip" {
  instance = "${aws_instance.xwiki_instance.id}"
  vpc      = true

  tags = "${merge("${var.tags}", map("Environment", "${terraform.workspace}", "Project", "${var.project}", "Service", "${var.service}", "Name", "${var.project}-${var.service}-${terraform.workspace}-xwiki-eip"))}"
}
