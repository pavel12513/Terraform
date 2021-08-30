
output "webserver_instanse_id" {
  value = aws_instance.my_webserver.id
}

output "webserver_public_ip_address" {
  value = aws_eip.my_static_ip.public_ip
}

output "webserver_public_ip_dns" {
  value = aws_eip.my_static_ip.public_dns
}

output "webserver_public_subnet_id" {
  value = aws_instance.my_webserver.subnet_id
}

output "webserver_network_interface" {
  value = aws_eip.my_static_ip.network_interface
}
