## XWiki outputs

output "xwiki_public_ip" {
  description = "The XWiki instance public ip"
  value       = "${aws_eip.xwiki_eip.public_ip}"
}

output "db_endpoint" {
  description = "The database endpoint"
  value       = "${module.db.this_db_instance_endpoint}"
}

output "db_hostname" {
  description = "The database hostname"
  value       = "${module.db.this_db_instance_address}"
}

output "db_port" {
  description = "The database listening port"
  value       = "${module.db.this_db_instance_port}"
}

output "db_name" {
  description = "The name of the database"
  value       = "${module.db.this_db_instance_name}"
}

output "db_user" {
  description = "The database username"
  value       = "${module.db.this_db_instance_username}"
}

output "db_password" {
  description = "The database password"
  value       = "${module.db.this_db_instance_password}"
}

## End of XWiki outputs

