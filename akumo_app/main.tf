resource "aws_instance" "akumo_app_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.akumo_app_sg.id]

  tags = merge(local.common_tags, local.env_tags[var.env])
}