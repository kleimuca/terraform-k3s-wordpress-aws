resource "aws_instance" "k3s" {
  count                     = 3
  ami                       = "ami-03250b0e01c28d196"
  instance_type             = "t3.medium"
  key_name                  = "key1"
  vpc_security_group_ids    = [aws_security_group.k3s_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "k3s-node-${count.index}"
  }
}