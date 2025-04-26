# 🧠 Terraform K3s WordPress Deployment – Detailed Instructions

---

## 💡 Prerequisites

- ✅ Terraform v1.0+
- ✅ AWS CLI & access configured
- ✅ SSH key pair in AWS
- ✅ Cloudflare account with:
  - API token
  - Zone ID
- ✅ Git installed

---

## 🔐 Secure Access Tips

- EC2 SSH access is protected via a security group
- Only ports `22` (SSH), `80` and `443` are exposed
- All other traffic is blocked by default

---

## 📜 Script Breakdown

| Script | Description |
|--------|-------------|
| `install_k3s_master.sh` | Installs K3s and prints the token for workers |
| `install_k3s_worker.sh` | Installs K3s worker and joins the cluster |
| `install_helm.sh`       | Installs Helm on the master node |
| `install_wordpress.sh`  | Deploys WordPress using Helm and sets DB |
| `setup_ingress.sh`      | Applies Ingress for external access via domain |

These scripts are triggered via Terraform's `remote-exec` feature on EC2 instances.

---

## 🌐 Cloudflare Integration

1. Requires Cloudflare email, API key/token, and zone ID
2. Terraform will:
   - Create DNS A record for your domain
   - Point to your load balancer IP or ingress controller

---

## 🧪 Testing the Site

After `terraform apply`, wait ~2–3 minutes for DNS propagation. Visit:

```
https://yourdomain.com
```

You should see the WordPress installation page.

---

## 🛠 Advanced Customization

Want to:
- Add autoscaling?
- Use EBS volumes?
- Deploy in VPC with private subnets?

These can be added by extending the modules in `main.tf`.

---

## 📂 Terraform File Explanation

| File | Purpose |
|------|---------|
| `main.tf`       | Core resource creation logic (EC2, provisioners) |
| `variables.tf`  | All input variables for configuration |
| `outputs.tf`    | Displays final DNS name, IPs, etc. |
| `terraform.tfvars` | Stores your custom variable values (git-ignored) |

---

## ✅ Best Practices

- Use a separate SSH key just for this project
- Never commit sensitive info (API keys, `.tfvars`)
- Consider using Terraform Cloud or state backend
