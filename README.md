# opentofu-oci-immich

Sets up an Immich server, on Oracle Cloud (to take advantage of free tier compute resources).

Uses AWS S3 and Glacier for backups and assumes an existing zone in R53 for the primary DNS record.

This will have some cost associated with it. The data volume attached to the OCI instance, for example, will be above the free tier. Also some minor cost for backups in S3/Glacier

# Notes

This is a work-in-progress!

Your current external ipv4 address is allowed to ssh to the instance in OCI. If your address changes, re-apply to update it before sshing to it.

## TODO

- Backups
- Safe instance rotation (stop the services)


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

# Operations

## Apply

The instance does take a good 5 minutes to configure itself on the first boot (cloud-init is used to bootstrap the instance).

## Replace the instance

./scripts/rotate-instance.sh

## Resize data partition

Note: never tested this

Note: growpart from cloud-init did not work; it shrank sda, even though I asked it to grow sdb

Input new size for the variable

tofu apply

ssh to the instance and resize the data volume
