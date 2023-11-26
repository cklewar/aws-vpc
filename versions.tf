terraform {
  required_version = ">= 1.2.7"
  cloud {
    organization = "cklewar"
    hostname     = "app.terraform.io"

    workspaces {
      name = "aws-vpc-module"
    }
  }
  
  required_providers {
    local = ">= 2.2.3"
    null = ">= 3.1.1"
  }
}