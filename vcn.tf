resource "oci_core_vcn" "main" {
  cidr_block     = "10.0.0.0/16"
  display_name   = "main"
  compartment_id = oci_identity_compartment.main.id
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_route_table" "main" {
  compartment_id = oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main.id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.main.id
  }
}

resource "oci_core_subnet" "subnet_1" {
  cidr_block     = "10.0.0.0/24"
  compartment_id = oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_route_table_attachment" "subnet_1" {
  subnet_id      = oci_core_subnet.subnet_1.id
  route_table_id = oci_core_route_table.main.id
}
