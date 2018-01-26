# resource "aws_instance" "test_db_connection" {
#   ami                         = "${data.aws_ami.centos_7.image_id}"
#   instance_type               = "t2.micro"
#   key_name                    = "${aws_key_pair.keypair.key_name}"
#   associate_public_ip_address = true
#   vpc_security_group_ids      = ["${module.security_group.this_security_group_id}"]
#   subnet_id                   = "${module.vpc.public_subnets[1]}"
#   tags {
#     Name        = "EUCP XWiki Test Instance"
#     Environment = "${terraform.workspace}"
#   }
# }

