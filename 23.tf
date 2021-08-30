provider "aws" {
  access_key = "AKIA3IEYEH4IKARS5UWW"
  secret_key = "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"
  region     = "eu-central-1"
}


resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!@$%^"
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master Password for RDS MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

data "aws_ssm_parameter" "my_rds_passowrd" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

resource "aws_db_instance" "default" {
  indentifier = "Prod"
  allocated_storage = 20
  storage_t

}


output "rds_passwor" {
  value     = data.aws_ssm_parameter.my_rds_passowrd.value
  sensitive = true
}
