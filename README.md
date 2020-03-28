# terraform-aws-vpc
Terraform Module for AWS VPC and subnets creation.
## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| availability\_zones | A list of availability zones in the region | `list(string)` | n/a | yes |
| aws\_region | AWS Region for develop infra | `string` | `"us-east-1"` | no |
| cidr\_block | CIDR for dev VPC | `string` | n/a | yes |
| database\_subnets | A list all the database subnets in the VPC | `list(string)` | n/a | yes |
| enable\_dns\_hostnames | Enable/Disable DNS hostnames in the VPC | `bool` | `true` | no |
| enable\_dns\_support | Enable/Disable DNS support in the VPC | `bool` | `true` | no |
| enable\_nat\_gateway | Enable/Disable nat gateway in public subnets to enable internet access in private subnet | `bool` | `true` | no |
| env | Deployment Environment | `string` | n/a | yes |
| instance\_tenancy | A tenancy option for instances in the VPC | `string` | `"default"` | no |
| private\_subnets | A list all the private subnets in the VPC | `list(string)` | n/a | yes |
| public\_subnets | A list all the public subnets in the VPC | `list(string)` | n/a | yes |
| service\_name | Name of the service | `string` | n/a | yes |
| tags | Tags for VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_db\_subnet\_group\_name | VPC database subnet group name |
| cidr\_block | VPC CIDR block |
| database\_subnets\_ids | VPC database subnet ids |
| id | VPC ID |
| private\_subnets\_ids | VPC private subnet ids |
| public\_subnet\_ids | VPC public subnet ids |

