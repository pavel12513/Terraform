provider "aws" {
  access_key = "AKIA3IEYEH4IKARS5UWW"
  secret_key = "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"
  region     = "eu-central-1"
}


variable "env" {
  default = "dev"
}
variable "server" {
  default = {
    prod = "t3.micro"
    dev  = "t2.micro"
  }
}
/*
variable "prod_owner" {
  default = "Pavel Akhanov"
}

variable "notprod_owner" {
  default = "Never"
}
*/
variable "name_of_server" {
  default = {
    prod = "My_Prod_Web_Server"
    dev  = "My_dev_server"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "22", "8080"]
  }
}
variable "ec2-size" {
  default = {
    "prod"     = "t3.medium"
    "dev"      = "t2.micro"
    "stanging" = "t3.small"
  }
}
resource "aws_instance" "my_web_server1" {
  ami                    = "ami-0453cb7b5f2b7fca2"
  instance_type          = var.env == "prod" ? var.server["prod"] : var.server["dev"]
  vpc_security_group_ids = [aws_security_group.my_WebServer.id]
  tags = {
    Name = var.env == "prod" ? var.name_of_server["prod"] : var.name_of_server["dev"]
  }
}


resource "aws_security_group" "my_WebServer" {
  name        = "Dunamic Security Groug"
  description = "My create security group"

  dynamic "ingress" {                               # Создание динамического блока кода
    for_each = lookup(var.allow_port_list, var.env) # Обозначаем, какие значения необходимо взять
    content {                                       # помещяем основной блок нашего кода
      from_port   = ingress.value                   # ingress.value обозначаем от куда брать переменные. ingress название динамической функции
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SecurityGroup For WebServer"
  }
}
/*
resource "aws_instance" "lear" {
  ami           = "ami-0453cb7b5f2b7fca2"
  instance_type = lookup(var.ec2-size, var.env)

  tags = {
    Name = "dev"
  }
}

resource "aws_instance" "learn" {
  ami           = "ami-0453cb7b5f2b7fca2"
  instance_type = lookup(var.ec2-size, var.env)
  tags = {
    Name = "stanging"
  }
}
*/
