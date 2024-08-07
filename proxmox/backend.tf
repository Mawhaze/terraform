terraform {
  backend "s3" {
    bucket = "mawhaze-terraform-state"
    key    = "proxmox/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform-lock-table"
    encrypt = true
  }
}