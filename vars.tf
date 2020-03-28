variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "env" {
  type        = string
  description = "Deployment Environment"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region for develop infra"
}

variable "cidr_block" {
  type        = string
  description = "CIDR for dev VPC"
}

variable "availability_zones" {
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "public_subnets" {
  type        = list(string)
  description = "A list all the public subnets in the VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "A list all the private subnets in the VPC"
}

variable "database_subnets" {
  type        = list(string)
  description = "A list all the database subnets in the VPC"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for VPC"
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances in the VPC"
  default     = "default"
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable/Disable DNS support in the VPC"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable/Disable DNS hostnames in the VPC"
  default     = true
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable/Disable nat gateway in public subnets to enable internet access in private subnet"
}
