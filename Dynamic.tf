provider "aws" {
  access_key = "AKIA3IEYEH4IC42KMB4R"
  secret_key = "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"
  region     = "eu-central-1"
}

resource "aws_security_group" "my_WebServer" {
  name        = "Dunamic Security Groug"
  description = "My create security group"

  dynamic "ingress" {                              # Создание динамического блока кода
    for_each = ["80", "443", "1200", "8080", "22"] # Обозначаем, какие значения необходимо взять
    content {                                      # помещяем основной блок нашего кода
      from_port   = ingress.value                  # ingress.value обозначаем от куда брать переменные. ingress название динамической функции
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
