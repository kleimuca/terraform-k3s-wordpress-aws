resource "null_resource" "create_wordpress_ingress" {
  depends_on = [null_resource.wait_for_wordpress_ready]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.k3s[0].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "cat <<EOF | kubectl apply -f -",
      "apiVersion: networking.k8s.io/v1",
      "kind: Ingress",
      "metadata:",
      "  name: wordpress-ingress",
      "  annotations:",
      "    nginx.ingress.kubernetes.io/rewrite-target: /",
      "    nginx.ingress.kubernetes.io/ssl-redirect: \"false\"",
      "spec:",
      "  rules:",
      "  - host: ${var.wordpress_domain}",
      "    http:",
      "      paths:",
      "      - path: /",
      "        pathType: Prefix",
      "        backend:",
      "          service:",
      "            name: wordpress",
      "            port:",
      "              number: 80",
      "EOF"
    ]
  }
}