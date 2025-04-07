resource "oci_core_instance" "main" {
  availability_domain = data.oci_identity_availability_domains.main.availability_domains[0].name
  compartment_id      = oci_identity_compartment.main.id
  display_name        = var.name
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet_1.id
    assign_public_ip = true

    nsg_ids = [
      oci_core_network_security_group.instance.id
    ]
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu24_aarch64.images.0.id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data           = data.template_cloudinit_config.main.rendered
  }

  lifecycle {
    ignore_changes = [
      metadata["user_data"]
    ]
  }
}

resource "oci_core_network_security_group" "instance" {
  compartment_id = oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_network_security_group_security_rule" "instance_ssh" {
  network_security_group_id = oci_core_network_security_group.instance.id
  direction                 = "INGRESS"
  protocol                  = "6" # tcp
  source                    = "${chomp(data.http.myip.response_body)}/32"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "instance_web" {
  for_each = toset(["80", "443"])

  network_security_group_id = oci_core_network_security_group.instance.id
  direction                 = "INGRESS"
  protocol                  = "6" # tcp
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = each.key
      max = each.key
    }
  }
}

resource "oci_core_network_security_group_security_rule" "instance_egress" {
  network_security_group_id = oci_core_network_security_group.instance.id
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  protocol                  = "all"
}

resource "oci_core_volume" "data" {
  availability_domain = data.oci_identity_availability_domains.main.availability_domains[0].name
  compartment_id      = oci_identity_compartment.main.id
  size_in_gbs         = var.data_volume_size
  display_name        = "${var.name}-data"
}

resource "oci_core_volume_attachment" "data" {
  instance_id = oci_core_instance.main.id
  volume_id   = oci_core_volume.data.id

  attachment_type = "paravirtualized"
}
