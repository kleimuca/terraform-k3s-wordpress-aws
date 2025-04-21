resource "null_resource" "join_k3s_workers" {
  count = 2

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.k3s[count.index + 1].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "if [ ! -f /etc/k3s_worker_installed ]; then",
      "  TOKEN=$(ssh -o StrictHostKeyChecking=no -i ${var.private_key_path} ubuntu@${aws_instance.k3s[0].public_ip} 'cat /home/ubuntu/k3s_token.txt')",
      "  curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s[0].private_ip}:6443 K3S_TOKEN=$TOKEN sh -",
      "  sudo touch /etc/k3s_worker_installed",
      "fi"
    ]
  }

  depends_on = [null_resource.init_k3s_master]
}