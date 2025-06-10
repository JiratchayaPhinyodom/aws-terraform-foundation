provider "aws" {
  region     = var.AWS_REGION
  profile    = "default"

}

terraform {
  required_version = ">= 1.0.5"
  backend "s3" {
    encrypt = true
    bucket = ""
    key    = ""
    region = ""
    profile = "default"
  }
}