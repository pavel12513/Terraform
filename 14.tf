#Локальные команды
provider "aws" {
  access_key = "AKIA3IEYEH4IKARS5UWW"
  secret_key = "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"
  region     = "ca-central-1"
}

resource "null_resource" "commant1" {
  provisioner "local-exec" {
    command = "ping www.google.com"
  }
}
/*
resource "null_resource" "command2" {
  provisioner "local-exec" {
    command     = "print('Hello World')"
    interpreter = ["python", "-c"]
  }

}
*/

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 >> names.txt"
    environment = {
      NAME1 = "Pavel"
      NAME2 = "Hello"
    }
  }
}
