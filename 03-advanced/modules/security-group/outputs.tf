output "name" {
  description = "Security Group Name"
  value       = aws_security_group.this.name
}

output "id" {
  description = "Security Group ID"
  value       = aws_security_group.this.id
}