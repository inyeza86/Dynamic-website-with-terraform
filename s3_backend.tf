terraform {
  backend "s3" {
    bucket  = "dynamic-website-terraform"
    key     = "dev1/terraform.tfstate"
    region  = "us-east-1"
    profile = "inyeza86"
  }
}
