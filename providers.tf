provider "aws" {
  region = "eu-central-1"
}

provider "kubernetes" {
  config_path = "/home/ubuntu/kubeconfig.yaml"
  insecure    = true
}

provider "helm" {
  kubernetes {
    config_path = "/home/ubuntu/kubeconfig.yaml"
    insecure    = true
  }
}
