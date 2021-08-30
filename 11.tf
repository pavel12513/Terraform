# Find AMI

provider "aws" {
  access_key = "AKIA3IEYEH4ICRYWCG5J"
  secret_key = "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"
  region     = "eu-central-1"
}

data "aws_ami" "latest_Ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*-amd64-server-*"]
  }
}



output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_Ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_Ubuntu.name
}

data "aws_ami" "Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

output "latest_amazon_ami_id" {
  value = data.aws_ami.Amazon_Linux.id
}

output "latest_amazon_ami_name" {
  value = data.aws_ami.Amazon_Linux.name
}
