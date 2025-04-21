variable "wordpress_domain" {
  description = "The domain name for WordPress"
  type        = string
  default     = "cyberflowtech.com"
}

variable "private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}