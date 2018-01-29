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

variable "ec2_instance_type" {
  description = "The EC2 instance type for the XWiki service"
  default     = "t2.micro"
}

## End of Main variables

## XWiki variables

variable "xwiki_version" {
  description = "XWiki version to install"
}

## XWiki variables

## Database variables

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

## End of Database variables

