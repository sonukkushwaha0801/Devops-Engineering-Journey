output "key_pair" {
  description = "Key pair used for the instance?"
  value       = var.key_pair != null ? "Yes, key used Name: " + var.key_pair : "No key pair specified"
}
