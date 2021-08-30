provider "aws" {
  access_key = "AKIA3IEYEH4IKWQ3GCW7"
  secret_key = "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"
  region     = "eu-central-1"
}


data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpcs" "vpns" {}


data "aws_vpc" "prod" {
  tags = {
    Name = "Server_for_learning"
  }
}

output "aws_vp" {
  value = data.aws_vpc.prod.id
}

output "aws_vp_block" {
  value = data.aws_vpc.prod.cidr_block
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}



/*
output "aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.working.zone_ids
}

output "aws_region" {
  value = data.aws_region.current.description
}

output "foo" {
  value = data.aws_vpcs.vpns.ids
}
*/
