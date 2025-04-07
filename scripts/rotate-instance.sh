#!/bin/bash

# Stop instance

tofu taint oci_core_instance.main
tofu apply

# Refresh known hosts
