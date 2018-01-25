## VPC outputs

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "database_subnet_group" {
  value = "${module.vpc.database_subnet_group}"
}

## End of VPC outputs

## XWiki outputs

output "public_ip" {
  description = "The XWiki instance public ip"
  value       = "${module.ec2_cluster.public_ip}"
}

## End of XWiki outputs

