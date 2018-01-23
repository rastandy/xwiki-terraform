variable "aws_region" {
  description = "The AWS Region"
  default     = "eu-central-1"
}

variable "service" {
  description = "The service name this resources are for"
  default     = "cmcc-eucp-xwiki"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}
