# opentofu-oci-immich

Sets up an Immich server, on Oracle Cloud (to take advantage of free tier compute resources).

Uses AWS S3 and Glacier for backups and assumes an existing zone in R53 for the primary DNS record.

This will have some cost associated with it. The data volume attached to the OCI instance, for example, will be above the free tier. Also some minor cost for backups in S3/Glacier


# Setup

https://docs.oracle.com/en-us/iaas/Content/dev/terraform/tutorials/tf-provider.htm

Create terraform.tfvars file (with all the necessary variables)

Create backend.tf, example (for OCI block storage):

```
terraform {
  backend "s3" {
    bucket    = "<bucket name>"
    key       = "terraform.tfstate"
    region    = "<region>"
    endpoints = { s3 = "https://<object-storage-namespace>.compat.objectstorage.<region>.oci.customer-oci.com" }

    profile                     = "oci"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}
```
