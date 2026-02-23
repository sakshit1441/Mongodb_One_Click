terraform {
  backend "s3" {
    bucket  = "sakshi-mongodb-tfstate"
    key     = "terraform/state.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
