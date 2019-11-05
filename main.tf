provider "aws" {
  region    = "ap-southeast-2"
  version = "~> 2.34"
}

terraform {
  backend "remote" {
    organization = "d3ba"

    workspaces {
      name = "lambda-test"
    }
  }
}