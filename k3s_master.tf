resource "null_resource" "init_k3s_master" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.k3s[0].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "for i in $(seq 1 30); do",
      "  nc -z -w5 ${aws_instance.k3s[1].private_ip} 3306 && break || echo 'Waiting for MySQL...'; sleep 5; ",
      "done",
      "if ! nc -z -w5 ${aws_instance.k3s[1].private_ip} 3306; then",
      "  echo 'MySQL is not available after 30 attempts. Exiting...' && exit 1",
      "fi",
      "if [ ! -f /etc/k3s_installed ]; then",
      "  echo 'Installing K3s...'",
      "  sudo apt-get update -y",
      "  sudo apt-get install -y netcat-openbsd",
      "  export INSTALL_K3S_EXEC=\"server --datastore-endpoint=mysql://admin:changeme@tcp(${aws_instance.k3s[1].private_ip}:3306)/k3s\"",
      "  curl -sfL https://get.k3s.io | sh -",
      "  until [ -f /etc/rancher/k3s/k3s.yaml ]; do sleep 2; done",
      "  sudo chmod 644 /etc/rancher/k3s/k3s.yaml",
      "  sudo cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/kubeconfig.yaml",
      "  sudo chown ubuntu:ubuntu /home/ubuntu/kubeconfig.yaml",
      "  sudo chmod 644 /home/ubuntu/kubeconfig.yaml",
      "  TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)",
      "  echo $TOKEN | sudo tee /home/ubuntu/k3s_token.txt",
      "  sudo chown ubuntu:ubuntu /home/ubuntu/k3s_token.txt",
      "  sudo touch /etc/k3s_installed",
      "fi"
    ]
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [null_resource.init_mysql_host]
}
