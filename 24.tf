# Conditions
provider "aws" {
  access_key = "AKIA3IEYEH4IKARS5UWW"
  secret_key = "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"
  region     = "eu-central-1"
}

variable "env" {
  default = "learn"
}

variable "prod_owner" {
  default = "Pavel Akhanov"
}

variable "notprod_owner" {
  default = "Never"
}

resource "aws_instance" "my_web_server1" {
  ami           = "ami-0453cb7b5f2b7fca2"
  instance_type = var.env == "prod" ? "t2.large" : "t2.micro"

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.notprod_owner
  }
}

resource "aws_instance" "lear" {
  count         = var.env == "learn" ? "1" : 0
  ami           = "ami-0453cb7b5f2b7fca2"
  instance_type = "t2.micro"

  tags = {
    Name = "${var.env}-server"
  }
}
