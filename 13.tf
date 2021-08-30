# Работа с переменными. Переменные в файле variables.tf
# Урок 19 и 20 
provider "aws" {
  access_key = "AKIA3IEYEH4IKARS5UWW"
  secret_key = "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"
  region     = var.region
}



data "aws_ami" "Amazon_Linux_Latest" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  /*
  tags = {
    Owner   = "Pavel"
    Project = "Fenix"
    Region  = var.region
  }
  */
  tags = merge(var.common_tags, { Name = "Server IP" })
}

resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.Amazon_Linux_Latest.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_server.id]
  monitoring             = var.enable_detailed_monitoring
  #  tags                   = var.common_tags
  tags = merge(var.common_tags, { Name = "My_Server" })
}

resource "aws_security_group" "my_server" {
  name = "My Security Group"
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }
}
