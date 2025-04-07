resource "oci_identity_compartment" "main" {
  name          = var.compartment_name
  description   = var.compartment_name
  enable_delete = true
}
