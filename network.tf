# Copyright © 2022, Oracle and/or its affiliates.
# All rights reserved. Licensed under the Universal Permissive License (UPL), Version 1.0 as shown at https://oss.oracle.com/licenses/upl.



# inputs

variable "compartment_id" {
  type = string
}

variable "vcn_display_name" {
  type = string
}

# outputs



# logic


# resource or mixed module blocks


module "vcn" {
    # https://developer.hashicorp.com/terraform/language/modules/sources#module-sources
   source = "github.com/JBAnderson5/oci-tf-network.git//network"

    compartment_id = var.compartment_id
    vcn_display_name = var.vcn_display_name
    cidr_blocks = ["10.0.0.0/16"]
    vcn_dns_label = "mydomain"

    create_internet_gateway = true
}


module "subnet" {
    source = "github.com/JBAnderson5/oci-tf-network.git//subnet"

    compartment_id = var.compartment_id
    network = module.vcn
    prefix = "ft"
    subnet_dns_label = "mysubdomain"
    cidr_block = "10.0.1.0/24"


    sl_rules = {
      "egress_traffic" = {
      dest_source_cidr = "anywhere"
  },
  "ssh_traffic" = {
    dest_source_cidr = "vcn"
    min = 22
  },
  "icmp_vcn" = {
    direction = "ingress"
    protocol = "icmp"
    dest_source_cidr = "vcn"
    min = 3
  },
  "icmp_anywhere" = {
    direction = "ingress"
    protocol = "icmp"
    dest_source_cidr = "anywhere"
    min = 3
    max = 4
  },


}

    
}