terraform {
  backend "s3" {
    bucket         = "cmcc-terraform-state"
    key            = "eucp-xwiki/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "cmcc_terraform_lock"
  }
}
