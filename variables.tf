# Define username/pass required by Azure
# Not used at all with GitHub images

variable "location" {
    type = string
}

variable "azure_sku" {
    type = string
    default = "Standard"
}

variable "domain" {
    type = string
}

variable "creator" {
    type = string
}


variable "ghes_version" {
    type = string
    description = "GitHub Enterprise Server version (e.g. 3.0.2)"
}

variable "cluster_name" {
    type = string
    description = "Cluster name (e.g. ghes3). Must be valid as part of a hostname."
}

variable "vm_size" {
    type = string
    description = "Azure VM size (e.g. Standard_DS12_v2)"
}

variable "root_disk_size" {
    type = number
    description = "Size of root disk for VMs"
    default = 200
}

variable "data_node_disk_size" {
    type = number
    description = "Size of /data/user disk for data-tier VMs"
    default = 100
}

variable "app_node_disk_size" {
    type = number
    description = "Size of /data/user disk for app-tier VMs"
    default = 100
}

variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
}
