variable "aws_region" {
  description = "The AWS Region"
  default     = "eu-central-1"
}

variable "service" {
  description = "The service name this resources are for"
  default     = "cmcc-eucp-xwiki"
}

variable "db_user" {
  description = "The database username"
  default     = "xwiki"
}

variable "db_password" {
  description = "The database password"
}
