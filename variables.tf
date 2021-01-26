variable "oracle_api_key_fingerprint" {
  description = "Oracle's key fingerprint"
  type        = string
}

variable "oracle_api_private_key_path" {
  description = "Path to Oracle's private key"
  type        = string
}

variable "ssh_public_key" {
  description = "Public key signature of the ssh key pair"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the private key of the ssh key pair"
  type        = string
}

variable "compartment_ocid" {
  description = "The OCID of the compartment. Use OCID from tenancy as fallback"
  type        = string
}
variable "tenancy_ocid" {
  description = "The OCID of the tenancy"
  type        = string
}
variable "user_ocid" {
  description = "The OCID of the user"
  type        = string
}

variable "region" {
  description = "List available: https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "prefix_display_name" {
  description = "Prefix for resources display names"
  default     = ""
  type        = string
}

variable "vcn_cidr_block" {
  description = "IPv4 CIDR block associated with the VCN."
  type        = string
  default     = "10.1.0.0/16"
}

variable "availability_domain_number" {
  description = "The number of the Availability Domain"
  type        = number
  default     = 1
}

variable "instance_shape" {
  description = "The shape of the instance. The shape determines the number of CPUs and the amount of memory allocated to the instance."
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "instance_image_ocid" {
  description = "Image OCID. List available: https://docs.cloud.oracle.com/en-us/iaas/images/image/cc81a889-bc7f-4b70-b8e7-0503812665be/"
  type        = map(string)

  default = {
    sa-saopaulo-1 = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa43nhxgl7mm57gssiqc4ajotp6awanjxn2m2cbju7qyic6cm3rtsq"
  }
}

variable "instance_count" {
  description = "Number of instances to spawn"
  type        = number
  default     = 2
}
