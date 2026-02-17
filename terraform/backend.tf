terraform {
  backend "s3" {
    bucket  = "oneclick-mongodb"
    key     = "aws_terraform/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
