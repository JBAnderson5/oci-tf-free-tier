# inputs

variable "create_adb" {
  type = bool 
  default = true
}

variable "adb_password" {
    type = string 
}

variable "adb_name" {
    type = string
    default = "freeadb"
  
}

variable "adb_workload" {
  type = string 
  default = "ADW" # ATP, JSON, APEX
}

variable "adb_version" {
    type = string 
    default = "23ai" # 19c
}



# outputs

# logic


# resource or mixed module blocks


resource "oci_database_autonomous_database" "this" {

  admin_password           = var.adb_password
  compartment_id           = var.compartment_id
  db_name                  = var.adb_name

  is_free_tier             = true
  db_version               = var.adb_version
  # cpu_core_count           = each.value.adw_cpu_core_count
  # data_storage_size_in_tbs = each.value.adw_size_in_tbs
  
  # display_name             = each.value.adw_db_name
  # db_workload              = each.value.adw_db_workload
  
  # is_auto_scaling_enabled  = each.value.adw_enable_auto_scaling
  
  # license_model            = each.value.adw_license_model
  # subnet_id                = each.value.subnet_id
  # nsg_ids                  = each.value.nsg_ids 
  # defined_tags             = each.value.defined_tags
}