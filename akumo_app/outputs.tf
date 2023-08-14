output "instance_private_ip" {
  description = "Private IP EC2"
  value       = aws_instance.akumo_app_instance.private_ip

}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.akumo_app_instance.id
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.akumo_app_instance.instance_state
}

output "instance_tags" {
  description = "Tags of the EC2 instance"
  value       = aws_instance.akumo_app_instance.tags_all
}
