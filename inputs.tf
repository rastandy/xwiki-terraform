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

## End of Main variables

## Database variables

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

