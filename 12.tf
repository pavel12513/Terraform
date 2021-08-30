provider "aws" {
  access_key = "AKIA3IEYEH4ICRYWCG5J"
  secret_key = "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"
  region     = "eu-central-1"
}


data "aws_availability_zones" "available" {}

data "aws_ami" "Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#-------------------------------------------------------------------

resource "aws_security_group" "web" {
  name        = "Dunamic Security Groug"
  description = "My create security group"

  dynamic "ingress" {              # Создание динамического блока кода
    for_each = ["80", "443", "22"] # Обозначаем, какие значения необходимо взять
    content {                      # помещяем основной блок нашего кода
      from_port   = ingress.value  # ingress.value обозначаем от куда брать переменные. ingress название динамической функции
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

resource "aws_launch_configuration" "web" {
  #  name            = "WebServer_Highly_Available_LC"
  name_prefix     = "WebServer_Highly_Available_LC-" #Берет начальное имя и добавляет в конец автоматически сгенерированнеы данные
  image_id        = data.aws_ami.Amazon_Linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"                             # Безе ASG и добавляем к нему название из aws_launch_configuration.web.name
  launch_configuration = aws_launch_configuration.web.name                                      # Вроде название
  min_size             = 2                                                                      # минимальнок кол-во серверов
  max_size             = 2                                                                      # максимальное кол-ве серверов
  min_elb_capacity     = 2                                                                      # сколько одновременно работает
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id] # в каких зонах запускать
  health_check_type    = "ELB"                                                                  # вроде за load balancer отвечает
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name   = "WebServer in AGS Server"
      Owner  = "Pavel Akhanov"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.web.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check { # Проверяет сайт по 80 порту что он доступен. Если становиться один из образов недоступен, автоматические создается еще один
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "WebServer_Highly_Available_ELB"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}
