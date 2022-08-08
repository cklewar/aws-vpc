# AWS-VPC

This repository consists of Terraform templates to bring up a AWS VPC with subnets.

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/cklewar/aws-vpc`
- Enter repository directory with: `cd aws-vpc`
- Export AWS `access_key` and `aws_secrect_key` environment variables
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

### Example Output

```bash
  # module.aws_vpc.aws_vpc.vpc will be created
  + resource "aws_vpc" "vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "192.168.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = false
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags_all                             = (known after apply)
    }

Plan: 9 to add, 0 to change, 0 to destroy.
```

## AWS VPC only

````hcl
module "aws_vpc" {
  source             = "./modules/aws/vpc"
  aws_az_name        = "us-east-1a"
  aws_region         = "us-east-1"
  aws_vpc_cidr_block = "192.168.0.0/16"
  aws_vpc_name       = "myVPC"
  custom_tags        = {
    Name  = "my_vpc"
    Owner = "c.klewar@f5.com"
  }
}
````

## AWS VPC with subnets

````hcl
module "aws_vpc" {
  source             = "./modules/aws/vpc"
  aws_az_name        = "us-east-1a"
  aws_region         = "us-east-1"
  aws_vpc_cidr_block = "192.168.0.0/16"
  aws_vpc_name       = "myVPC"
  custom_tags        = {
    Name  = "my_vpc"
    Owner = "c.klewar@f5.com"
  }
}

variable "aws_vpc_subnets" {
  type = list(object({
    name                    = string
    map_public_ip_on_launch = bool
    cidr_block              = string
    availability_zone       = string
  }))
  default = [
    {
      name                    = "my_subnet_A"
      map_public_ip_on_launch = true
      cidr_block              = "192.168.0.0/24"
      availability_zone       = "us-west-2a"
    },
    {
      name                    = "my_subnetB"
      map_public_ip_on_launch = true
      cidr_block              = "192.169.0.0/24"
      availability_zone       = "us-west-2a"
    }
  ]
}

provider "aws" {
  region = "us-west-2"
  alias = "default"
}

module "aws_subnet" {
  for_each                        = {for k, v in var.aws_vpc_subnets :  k => v}
  source                          = "./modules/aws/subnet"
  aws_az_name                     = each.value.availability_zone
  aws_subnet_name                 = each.value.name
  aws_vpc_id                      = module.aws_vpc.aws_vpc_id
  aws_vpc_map_public_ip_on_launch = each.value.map_public_ip_on_launch
  subnet_cidr_block               = each.value.cidr_block
  custom_tags                     = {
    Name  = "my_vpc"
    Owner = "c.klewar@f5.com"
  }

  providers = {
    aws = aws.default
  }
}
````

