variable "aws_region" {
  description = "The AWS Region"
  default     = "eu-central-1"
}

variable "service" {
  description = "The service name this resources are for"
  default     = "cmcc-eucp-xwiki"
}

output "public_ip" {
  description = "The XWiki instance public ip"
  value       = "${module.ec2_cluster.public_ip}"
}
