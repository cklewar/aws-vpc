variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "01"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

provider "aws" {
  region = var.aws_region
  alias  = "default"
}

module "aws_vpc" {
  source             = "./modules/aws/vpc"
  aws_owner          = "c.klewar@f5.com"
  aws_region         = "us-east-2"
  aws_az_name        = "us-east-2a"
  aws_vpc_name       = format("%s-aws-vpc-%s", var.project_prefix, var.project_suffix)
  aws_vpc_cidr_block = "172.16.40.0/21"
  custom_tags        = {
    Name  = format("%s-aws-vpc-%s", var.project_prefix, var.project_suffix)
    Owner = "c.klewar@f5.com"
  }
  providers = {
    aws = aws.default
  }
}