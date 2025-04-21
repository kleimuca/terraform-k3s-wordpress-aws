resource "null_resource" "init_mysql_host" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.k3s[1].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "if [ ! -f /etc/mysql_installed ]; then",
      "  sudo apt-get update -y",
      "  sudo apt-get install -y mysql-server",
      "  echo -e '[mysqld]\\nbind-address = 0.0.0.0' | sudo tee /etc/mysql/mysql.conf.d/mysqld.cnf",
      "  sudo systemctl restart mysql",
      "  sudo systemctl enable mysql",
      "  sudo mysql -e \"CREATE DATABASE IF NOT EXISTS k3s;\"",
      "  sudo mysql -e \"CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'changeme';\"",
      "  sudo mysql -e \"GRANT ALL PRIVILEGES ON k3s.* TO 'admin'@'%';\"",
      "  sudo mysql -e \"FLUSH PRIVILEGES;\"",
      "  sudo touch /etc/mysql_installed",
      "fi"
    ]
  }

  depends_on = [aws_instance.k3s]
}
