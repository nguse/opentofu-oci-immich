provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

provider "oci" {
  config_file_profile = "DEFAULT"
}
