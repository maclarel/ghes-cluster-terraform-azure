# Define username/pass required by Azure
# Not used at all with GitHub images

variable "location" {
    type = string
}

variable "azure_sku" {
    type = string
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

variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
}
