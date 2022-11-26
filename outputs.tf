output "instance_amd_display_name" {
  description = "Display name of created amd instances."
  value       = oci_core_instance.instance_amd[*].display_name
}

output "instance_amd_id" {
  description = "OCID of created amd instances."
  value       = oci_core_instance.instance_amd[*].id
}

output "private_amd_ip" {
  description = "Private IPs of created amd instances."
  value       = oci_core_instance.instance_amd[*].private_ip
}

output "public_amd_ip" {
  description = "Public IPs of created amd instances."
  value       = oci_core_instance.instance_amd[*].public_ip
}

output "instance_arm_display_name" {
  description = "Display name of created arm instances."
  value       = oci_core_instance.instance_arm[*].display_name
}

output "instance_arm_id" {
  description = "OCID of created arm instances."
  value       = oci_core_instance.instance_arm[*].id
}

output "private_arm_ip" {
  description = "Private IPs of created arm instances."
  value       = oci_core_instance.instance_arm[*].private_ip
}

output "public_arm_ip" {
  description = "Public IPs of created arm instances."
  value       = oci_core_instance.instance_arm[*].public_ip
}
