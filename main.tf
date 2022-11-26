resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = "${var.prefix_display_name} Virtual Cloud Network"
  dns_label      = "${var.prefix_display_name}vcn"
}

resource "oci_core_subnet" "subnet" {
  depends_on          = [oci_core_security_list.security_list, oci_core_vcn.vcn]
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = var.vcn_cidr_block
  display_name        = "${var.prefix_display_name} Subnet"
  dns_label           = "${var.prefix_display_name}subnet"
  security_list_ids   = [oci_core_security_list.security_list.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.vcn.id
  route_table_id      = oci_core_vcn.vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "internet_gateway" {
  depends_on     = [oci_core_vcn.vcn]
  compartment_id = var.compartment_ocid
  display_name   = "${var.prefix_display_name} Internet Gateway"
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_default_route_table" "route_table" {
  depends_on                 = [oci_core_vcn.vcn, oci_core_internet_gateway.internet_gateway]
  display_name               = "${var.prefix_display_name} Route Table"
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_security_list" "security_list" {
  depends_on     = [oci_core_vcn.vcn]
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.prefix_display_name} Security List"

  egress_security_rules {
    description = "${var.prefix_display_name} Outbound All"
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  // Protocol: 6 = TCP, 17 = UDP
  dynamic "ingress_security_rules" {
    iterator = rule
    for_each = toset(var.ingress_allowed_tcp)
    content {
      description = "${var.prefix_display_name} Inbound TCP ${rule.value}"
      protocol    = "6"
      source      = "0.0.0.0/0"
      stateless   = false

      tcp_options {
        source_port_range {
          min = 1
          max = 65535
        }

        min = rule.value
        max = rule.value
      }
    }
  }

  dynamic "ingress_security_rules" {
    iterator = rule
    for_each = toset(var.ingress_allowed_udp)
    content {
      description = "${var.prefix_display_name} Inbound UDP ${rule.value}"
      protocol    = "17"
      source      = "0.0.0.0/0"
      stateless   = false

      udp_options {
        source_port_range {
          min = 1
          max = 65535
        }

        min = rule.value
        max = rule.value
      }
    }
  }

  ingress_security_rules {
    description = "${var.prefix_display_name} Inbound ICMP"
    protocol    = 1
    source      = "0.0.0.0/0"
    stateless   = false

    icmp_options {
      type = 3
      code = 4
    }
  }
}

resource "oci_core_volume_backup_policy_assignment" "volume_backup_policy_assignment" {
  asset_id  = oci_core_volume.storage.id
  policy_id = "ocid1.volumebackuppolicy.oc1..aaaaaaaagcremuefit7dpcnjpdrtphjk4bwm3emm55t6cghctt2m6iyyjdva"
}

resource "oci_core_volume" "storage" {
  compartment_id = var.compartment_ocid

  display_name = "${var.prefix_display_name} volume"

  size_in_gbs         = var.storage_size_in_gbs
  vpus_per_gb         = 10
  availability_domain = data.oci_identity_availability_domain.ad.name
}

resource "oci_core_volume_attachment" "volume_amd_attachment" {
  count           = var.instance_amd_count
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.instance_amd[count.index].id
  volume_id       = oci_core_volume.storage.id

  is_read_only = false
  is_shareable = true
}

resource "oci_core_volume_attachment" "volume_arm_attachment" {
  count           = var.instance_arm_count
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.instance_arm[count.index].id
  volume_id       = oci_core_volume.storage.id

  is_read_only = false
  is_shareable = true
}

resource "oci_core_instance" "instance_amd" {
  depends_on = [oci_core_subnet.subnet, oci_core_volume.storage]
  count      = var.instance_amd_count

  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix_display_name} AMD Instance ${count.index}"
  shape               = var.instance_amd_shape

  shape_config {
    ocpus         = var.instance_amd_shape_config.ocpus
    memory_in_gbs = var.instance_amd_shape_config.memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    display_name     = "${var.prefix_display_name} AMD VNIC${count.index}"
    assign_public_ip = true
    hostname_label   = "${var.prefix_display_name}instance${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_amd_image_ocid
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      name          = "Compute Instance Monitoring"
      desired_state = "ENABLED"
    }
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_instance" "instance_arm" {
  depends_on = [oci_core_subnet.subnet, oci_core_volume.storage]
  count      = var.instance_arm_count

  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix_display_name} ARM Instance ${count.index}"
  shape               = var.instance_arm_shape

  shape_config {
    ocpus         = var.instance_arm_shape_config.ocpus
    memory_in_gbs = var.instance_arm_shape_config.memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    display_name     = "${var.prefix_display_name} ARM VNIC${count.index}"
    assign_public_ip = true
    hostname_label   = "${var.prefix_display_name}instance${var.instance_amd_count + count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_arm_image_ocid
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      name          = "Compute Instance Monitoring"
      desired_state = "ENABLED"
    }
  }

  timeouts {
    create = "60m"
  }
}

resource "cloudflare_record" "main" {
  count = length(var.cloudflare_main_names)
  zone_id = var.cloudflare_zone_id
  name    = var.cloudflare_main_names[count.index]
  value   = oci_core_instance.instance_amd[0].public_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "instance_amd_names" {
  count = length(oci_core_instance.instance_amd)
  zone_id = var.cloudflare_zone_id
  name    = "${var.cloudflare_instance_name}${count.index}"
  value   = oci_core_instance.instance_amd[count.index].public_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "instance_arm_names" {
  depends_on = [oci_core_instance.instance_arm, oci_core_instance.instance_amd]
  count = length(oci_core_instance.instance_arm)
  zone_id = var.cloudflare_zone_id
  name    = "${var.cloudflare_instance_name}${length(oci_core_instance.instance_amd)+count.index}"
  value   = oci_core_instance.instance_arm[count.index].public_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "instance_amd_wildcard_names" {
  count = length(oci_core_instance.instance_amd)
  zone_id = var.cloudflare_zone_id
  name    = "*.${var.cloudflare_instance_name}${count.index}"
  value   = oci_core_instance.instance_amd[count.index].public_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "instance_arm_wildcard_names" {
  count = length(oci_core_instance.instance_arm)
  zone_id = var.cloudflare_zone_id
  name    = "*.${var.cloudflare_instance_name}${length(oci_core_instance.instance_amd)+count.index}"
  value   = oci_core_instance.instance_arm[count.index].public_ip
  type    = "A"
  proxied = false
}
