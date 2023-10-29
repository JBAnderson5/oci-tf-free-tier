
# inputs

variable "compartment_id" {
  type        = string
  description = "ocid of the compartment to create resources in."
}

variable "instance_name" {
    type = string
}

variable "ad" {
	type = string
}

variable "os" {

}



# outputs


# logic

locals {
  shape = "VM.Standard.E2.1.Micro"
}

# resource or mixed module blocks


data "oci_core_images" "test_images" {
    #Required
    compartment_id = var.compartment_id

   
    operating_system = var.os
    # operating_system_version = var.image_operating_system_version
    shape = local.shape
    state = var.image_state
    # sort_by = var.image_sort_by
    # Ssort_order = var.image_sort_order
}

data "oci_identity_availability_domain" "this" {
    compartment_id = var.tenancy_ocid

    #id = var.ad
    ad_number = var.ad
}

resource "oci_core_instance" "this" {
    display_name = var.instance_name

    compartment_id = var.compartment_id

    # Placement
    availability_domain = data.oci_identity_availability_domain.this.ad_number #"gyIV:PHX-AD-2"
    # Fault Domain
    # Capacity Type
    
    # Security
    # Shielded Instance
    # Confidential Computing


    # Image and Shape
    source_details {
		source_id = data.oci_core_images.this.images[0].id
		source_type = "image"
	}
    shape = local.shape

    # Vnic info
    create_vnic_details {
		assign_ipv6ip = "false"
		assign_private_dns_record = "true"
		assign_public_ip = "false"
		subnet_id = local.subnet_id 
	}
    # IPV6
    # DNS
    # VCN/Subnet Tags?

    
    ## SSH keys
    metadata = {
		"user_data" = "IyEvYmluL2Jhc2gKc3VkbyBhcHQgdXBkYXRlICYmIHN1ZG8gYXB0IHVwZ3JhZGU="
		"ssh_authorized_keys" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCWuECJQA/GZLPCR///6rUSIPYjfkuwjxHRHJ+I5pS+WdQDdPSjvfH3fKAITlRnO5t57tNDpwooQSZh6v6eK9tPHu1XzeBUVRLgflusPjfgtK4pFLKmBJN0PaZ2G4CvGDvWvb7+DYpWrNgb2pCuMf2nz375IbSwBFAJx7CIkuqefLd3r4APfpGluDTdk3ibJu/wdCQQDMqxWYpomPvYA1wJgnZcfCn1ZsZM2cJVzOtYzzadgLjKYaxtKjQznMLNd+CrysEbLERxF9lBmEiARxFHfkGQYDfyOMmeHsYQgzG/fvYLWnGXRauPDqGSDQNB7Y2abdPzuD5exp+6IPnD12LmzcwBfvEy/NMdac9DmQPpFDX5cctIg7SpRmO0zK20cAHePyU0KFmdBJIGNavltFrsqsuWrFous+1He5O8S3z/AEYDJ5mky/4tttfBChq1HINzITGf7ypeEUWeqCtp5gbX1qBojeYZecLBUIn/6UT+k2etzRQjfF+fPHhdbIdNFE1KoI2I8g2SnPXcMh9am0EXCF8KOL6RxovCinf2pZBYauFbOZrj6xoy+0jlSNEa5dtZAx3SfT+jVgDeNnRQCy2XQp0WFe0SLQBKMNJGb8tCXEcKgde+QqMgYMBg7YJCVuYd5k5ZamDmtbIEHboWZDggZM676P7XQFSM3VBO+jlMow== jbhermosa5@gmail.com"
	}

    # Boot Volume
    # custom size and performance
    is_pv_encryption_in_transit_enabled = "true"
    # custom encryption key


    # management
    instance_options { 
		are_legacy_imds_endpoints_disabled = "false" # auth header. Does IMDSv1 vs v2 matter?
	}
    # tagging

    # Availability Configuration
    availability_config {
		recovery_action = "RESTORE_INSTANCE"
	}
    # live migration

    # Oracle Cloud Agent
	agent_config {
		is_management_disabled = "false"
		is_monitoring_disabled = "false"
		plugins_config {
			desired_state = "ENABLED"
			name = "Vulnerability Scanning"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Oracle Java Management Service"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "OS Management Service Agent"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Management Agent"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Custom Logs Monitoring"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute RDMA GPU Monitoring"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Run Command"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Monitoring"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute HPC RDMA Auto-Configuration"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute HPC RDMA Authentication"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Block Volume Management"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Bastion"
		}
	}

}
