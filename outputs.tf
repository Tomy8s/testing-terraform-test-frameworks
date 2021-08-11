output "public_ip" {
  value = aws_instance.test-instance.public_ip
}

output "instance_id" {
  value = aws_instance.test-instance.id
}

output "hello_world" {
  value = "Hello, World!"
}
