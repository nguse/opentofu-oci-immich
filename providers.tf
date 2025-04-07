provider "aws" {
  profile = var.aws_profile
}

provider "oci" {
  config_file_profile = var.oci_profile
}
