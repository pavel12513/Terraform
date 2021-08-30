provider "aws" {
  access_key = "AKIA3IEYEH4IKWQ3GCW7"
  secret_key = "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"
  region     = "eu-central-1"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0453cb7b5f2b7fca2" #Amazon_Linux_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Web_server"
  }
  depends_on = [aws_instance.my_server_db]
}

resource "aws_instance" "my_server_app" {
  ami                    = "ami-0453cb7b5f2b7fca2" #Amazon_Linux_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Web_server"
  }

  depends_on = [aws_instance.my_server_db]
}


resource "aws_instance" "my_server_db" {
  ami                    = "ami-0453cb7b5f2b7fca2" #Amazon_Linux_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Web_server"
  }
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
