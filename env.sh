#!/usr/bin/env bash
#Enter Your Tenancy OCID
export TF_VAR_tenancy_ocid="Enter your tenancy OCID here"
#Enter Your User OCID
export TF_VAR_user_ocid="Enter your user OCID here"
#Enter Your Fingerprint
export TF_VAR_fingerprint="Enter your fingerprint here"
#Enter Your Region (Example: us-ashburn-1)
export TF_VAR_region="us-ashburn-1"
#Enter the Image OCID
export TF_VAR_image_ocid="ocid1.image.oc1.iad.aaaaaaaawufnve5jxze4xf7orejupw5iq3pms6cuadzjc7klojix6vmk42va"
#Enter Shape for Instance (Example: VM.Standard2.1)
export TF_VAR_instance_shape="VM.Standard2.1"
#Enter Path to Your Private API Key
export TF_VAR_private_key_path="/Enter /the /path /to /private /PEM /key"
#Enter Path to Your Public SSH Key
export TF_VAR_ssh_public_key=$(cat /Enter /the /path /to /instance /ssh /public /key)
#Enter Path to Your Private SSH Key
export TF_VAR_ssh_authorized_private_key=$(cat /Enter /the /path /to /instance /ssh /private /key)
