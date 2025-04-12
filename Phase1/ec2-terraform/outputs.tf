output "instance_id" {
    description = "The ID of the EC2 instance"
    value       = aws_instance.ec2_instance.id
}

output "public_ip" {
    description = "Public IP of the EC2 instance"
    value = aws_eip.my_eip.public_ip
}