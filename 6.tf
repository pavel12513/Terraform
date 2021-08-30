provider "aws" {
  access_key = "AKIA3IEYEH4IC42KMB4R"
  secret_key = "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"
  region     = "eu-central-1"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0453cb7b5f2b7fca2" #Amazon_Linux_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Pavel",
    l_name = "Akhanov",
    names  = ["Vasya", "Ola", "Patya", "Igor", "XYZ", "Hello", "Ahahaha"]
  })
  tags = {
    Name = "Web_server"
  }

  lifecycle {
    create_before_destroy = true
    #    prevent_destroy = true
    #    ignore_changes = ["ami", "user_data"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My firs SecurityGroup"

  ingress { #Какой доступ разрешен из вне
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { #Какой доступ разрешен из вне
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { # Какой доступ разрешен с виртуальной машины
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #-1 Любой протокол или указать конкретный
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "webserver_instanse_id" {
  value = aws_instance.my_webserver.id
}

output "webserver_public_ip_address" {
  value = aws_eip.my_static_ip.public_ip
}
