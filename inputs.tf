## Main variables
variable "aws_region" {
  description = "The AWS Region"
  default     = "eu-central-1"
}

variable "project" {
  description = "The project for which this resources are for"
  default     = "EUCP"
}

variable "service" {
  description = "The service name this resources are for"
  default     = "eucp-xwiki"
}

variable "tags" {
  type        = "map"
  description = "Optional Tags"
  default     = {}
}

variable "database_backup_retention_period" {
  description = "Number of days a db backup will be retained"
  default     = 30
}

variable "ec2_instance_type" {
  description = "The EC2 instance type for the XWiki service"
  default     = "t2.micro"
}

## End of Main variables

## XWiki variables
variable "xwiki_ami" {
  description = "XWiki ami to use for booting the instance"
}

# variable "xwiki_version" {
#   description = "XWiki version to install"
# }

variable "xwiki_permanent_dir_volume_block_device" {
  description = "XWiki permanentDirectory volume size"
  default     = "/dev/xvdh"
}

variable "xwiki_permanent_directory_volume_size" {
  description = "XWiki permanentDirectory volume size"
  default     = 5
}

variable "servername" {
  description = "XWiki instance domain name"
}

variable "ec2_key_file" {
  description = "XWiki instance SSH access key"
}

variable "xwiki_permanent_directory_snapshot_id" {
  description = "XWiki snapshot of a preexisting permanent directory volume"
  default     = ""
}

## End of XWiki variables

## Database variables

variable "db_allocated_storage" {
  description = "The database size in Gb"
  default     = 5
}

variable "db_instance_type" {
  description = "The database EC2 instance type"
  default     = "db.t2.micro"
}

variable "db_port" {
  description = "The database port number"
  default     = "5432"
}

variable "db_user" {
  description = "The database username"
  default     = "xwiki"
}

variable "db_password" {
  description = "The database password"
}

variable "xwiki_db_snapshot_id" {
  description = "Snapshot of a preexisting XWiki database"
  default     = ""
}

## End of Database variables

