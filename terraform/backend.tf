terraform {
  backend "s3" {
    bucket  = "oneclick-mongodb"
    key     = "aws_terraform/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
