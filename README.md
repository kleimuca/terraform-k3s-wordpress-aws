# 🚀 K3s WordPress Infrastructure on AWS (via Terraform)

This project automates the deployment of a **WordPress website** using **Terraform** and a **K3s Kubernetes cluster** on **AWS EC2** instances. It features a fully working setup with MySQL, Helm, NGINX Ingress, and DNS configured via **Cloudflare**.

---

## 🔧 What It Does

- Provisions 4 EC2 instances:
  - 🛢 1x MySQL database node
  - 🧠 1x K3s master node
  - 💪 2x K3s worker nodes
- Installs and configures:
  - ✅ K3s (lightweight Kubernetes)
  - ✅ Helm
  - ✅ WordPress via Helm chart
  - ✅ NGINX Ingress
- Manages DNS via **Cloudflare API**
- Secures access via custom security groups
- Uses **Terraform provisioners** to automate SSH-based remote commands

---

## 📁 Project Structure

```
k3s-wordpress-infra/
├── README.md
├── instructions.md            # (Full usage guide & advanced explanation)
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars           # Store your custom variable values here
├── scripts/
│   ├── install_k3s_master.sh
│   ├── install_k3s_worker.sh
│   ├── install_helm.sh
│   ├── install_wordpress.sh
│   └── setup_ingress.sh
└── templates/
    └── wordpress-ingress.yaml.tpl
```

---

## ⚙️ Quickstart

### 1. Clone the Repo

```bash
git clone https://github.com/kleimuca/terraform-k3s-wordpress-aws.git
cd terraform-k3s-wordpress-aws
```

### 2. Configure Variables

Edit the `terraform.tfvars` file:

```hcl
aws_region         = "us-east-1"
key_name           = "your-key-name"
private_key_path   = "~/.ssh/id_rsa"
wordpress_domain   = "yourdomain.com"

cloudflare_email   = "you@example.com"
cloudflare_api_key = "your_cloudflare_api_key"
cloudflare_zone_id = "your_cloudflare_zone_id"
```

### 3. Deploy

```bash
terraform init
terraform apply
```

Terraform will:
- Launch EC2s
- Install K3s & WordPress
- Set up Helm, DNS, and ingress

---

## 🧹 Destroy Resources

```bash
terraform destroy
```

This cleans up everything deployed.

---

## 📬 Questions?

Open an issue or contribute via [GitHub](https://github.com/kleimuca/terraform-k3s-wordpress-aws).
