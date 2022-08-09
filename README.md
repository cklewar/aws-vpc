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

## AWS VPC

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