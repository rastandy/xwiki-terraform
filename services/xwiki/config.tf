terraform {
  backend "s3" {
    bucket         = "cmcc-eucp-xwiki-remote-state"
    key            = "services/xwiki/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "cmcc_terraform_lock"
  }
}
