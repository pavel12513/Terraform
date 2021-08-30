# Count and for_it
provider "aws" {
  access_key = "AKIA3IEYEH4IKARS5UWW"
  secret_key = "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"
  region     = "eu-central-1"
}

variable "aws_users" {
  description = "List of IAM user"
  default     = ["vasya", "petya", "lena", "HAHAHAHA"]
}

resource "aws_iam_user" "user1" {
  name = "pushkin"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

output "created_users_all" {
  value = aws_iam_user.users
}
output "created_users_id" {
  value = aws_iam_user.users[*].id
}

output "created_iam_users_customer" {
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.name} has ARN: ${user.arn}"
  ]
}



# ------------------------------------------------------------
resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-0453cb7b5f2b7fca2"
  instance_type = "t2.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}
