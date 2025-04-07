data "oci_core_images" "ubuntu24_aarch64" {
  compartment_id   = oci_identity_compartment.main.id
  operating_system = "Canonical Ubuntu"
  sort_by          = "TIMECREATED"

  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-24.04-aarch64-([\\.0-9-]+)$"]
    regex  = true
  }
}

data "oci_identity_availability_domains" "main" {
  compartment_id = oci_identity_compartment.main.id
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

data "aws_route53_zone" "main" {
  name = var.zone_name
}

data "template_file" "cloudinit" {
  template = file("${path.module}/files/cloudinit.yaml")

  vars = {
    domain_name       = var.domain_name
    module_path       = path.module
    postgres_password = random_password.postgres_password.result
  }
}

data "template_cloudinit_config" "main" {
  base64_encode = true

  part {
    filename     = "init.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.cloudinit.rendered
  }
}

resource "random_password" "postgres_password" {
  length  = 32
  special = false
}
