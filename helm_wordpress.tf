resource "null_resource" "init_helm_on_master" {
  depends_on = [null_resource.init_k3s_master]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.k3s[0].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash",
      "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml",
      "helm repo add bitnami https://charts.bitnami.com/bitnami",
      "helm repo update",
      "helm upgrade --install wordpress bitnami/wordpress \\",
      "  --namespace default \\",
      "  --set wordpressUsername=admin \\",
      "  --set wordpressPassword=changeme \\",
      "  --set wordpressEmail=user@example.com \\",
      "  --set wordpressBlogName=CyberFlowTech \\",
      "  --set mariadb.enabled=false \\",
      "  --set externalDatabase.host=${aws_instance.k3s[1].private_ip} \\",
      "  --set externalDatabase.user=admin \\",
      "  --set externalDatabase.password=changeme \\",
      "  --set externalDatabase.database=k3s \\",
      "  --set ingress.enabled=true \\",
      "  --set ingress.hostname=${var.wordpress_domain}"
    ]
  }
}

resource "null_resource" "wait_for_wordpress_ready" {
  depends_on = [null_resource.init_helm_on_master]

  connection {
    type        = "ssh"
    host        = aws_instance.k3s[0].public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "until kubectl get pods -l app.kubernetes.io/name=wordpress -o jsonpath='{.items[0].status.containerStatuses[0].ready}' | grep true; do sleep 5; done"
    ]
  }
}
