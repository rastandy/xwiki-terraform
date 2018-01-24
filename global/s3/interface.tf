variable "aws_region" {
  description = "The AWS Region"
  default     = "eu-central-1"
}

variable "remote_state_prefix" {
  description = "Remote state bucket prefix"
}

output "remote_state_id" {
  description = "Remote state output id"
  value       = "${module.remote_state.s3_bucket_id}"
}
