provider "aws" {
  access_key = "AKIA3IEYEH4IC42KMB4R"
  secret_key = "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"
  region     = "eu-central-1"
}

resource "aws_instance" "my_Ubuntu1" {
  count         = 1 #кол-во серверов
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"

  tags = {
    Name  = "My Amazon Linux"
    Owner = "Pavel"
  }
}

resource "aws_instance" "my_Amazon1" {
  ami           = "ami-0453cb7b5f2b7fca2"
  instance_type = "t2.micro"

  tags = {
    Name  = "My Amazon Server"
    Owner = "Pavel"
  }
}
