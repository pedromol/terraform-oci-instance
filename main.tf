provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.oracle_api_key_fingerprint
  private_key_path = var.oracle_api_private_key_path
  region           = var.region
}

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

resource "oci_core_instance" "instance" {
  depends_on = [oci_core_subnet.subnet]
  count      = var.instance_count

  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix_display_name} Instance ${count.index}"
  shape               = var.instance_shape[count.index]

  shape_config {
    ocpus         = var.instance_shape_config[count.index].ocpus
    memory_in_gbs = var.instance_shape_config[count.index].memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    display_name     = "${var.prefix_display_name} VNIC${count.index}"
    assign_public_ip = true
    hostname_label   = "${var.prefix_display_name}instance${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[count.index]
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
