terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    oci = {
      source  = "oracle/oci"
      version = ">=4.67.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0.0"
}
