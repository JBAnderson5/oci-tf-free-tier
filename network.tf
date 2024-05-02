# Copyright © 2022, Oracle and/or its affiliates.
# All rights reserved. Licensed under the Universal Permissive License (UPL), Version 1.0 as shown at https://oss.oracle.com/licenses/upl.



# inputs

variable "create_network" {
  type = bool 
  default = true 
}

variable "vcn_display_name" {
  type = string
}

variable "vcn_id" {
  default = null
}

variable "subnet_id" {
  default = null
}

# outputs



# logic

locals {
  subnet_id = (
    var.subnet_id != null 
      ? var.subnet_id 
      : var.create_network
        ? module.public-subnet[0].subnet.id
        : null
  )
}


# resource or mixed module blocks


module "vcn" {
   source = "github.com/JBAnderson5/oci-tf-network.git//network"
    count = var.vcn_id == null && var.create_network ? 1 : 0

    compartment_id = var.compartment_id
    vcn_display_name = var.vcn_display_name
    cidr_blocks = ["10.0.0.0/16"]
    vcn_dns_label = "mydomain"

    create_internet_gateway = true
}


module "public-subnet" {
    source = "github.com/JBAnderson5/oci-tf-network.git//subnet"
    count = var.subnet_id == null && var.create_network ? 1 : 0

    compartment_id = var.compartment_id
    network = var.vcn_id == null ? module.vcn[0] : var.vcn_id # todo need vcn module data source
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

module "private-subnet" {
    source = "github.com/JBAnderson5/oci-tf-network.git//subnet"
    count = var.create_network ? 1 : 0

    compartment_id = var.compartment_id
    vcn = module.vcn[0].vcn 

    prefix = "private"
    subnet_dns_label = "myprivdomain"
    cidr_block = "10.0.2.0/24"


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