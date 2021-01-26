output "instance_display_name" {
  description = "Display name of created instances."
  value       = oci_core_instance.instance[*].display_name
}

output "instance_id" {
  description = "OCID of created instances."
  value       = oci_core_instance.instance[*].id
}

output "private_ip" {
  description = "Private IPs of created instances."
  value       = oci_core_instance.instance[*].private_ip
}

output "public_ip" {
  description = "Public IPs of created instances."
  value       = oci_core_instance.instance[*].public_ip
}
