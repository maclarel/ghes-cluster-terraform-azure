# Define username/pass required by Azure
# Not used at all with GitHub images

variable "location" {
    type = string
}

variable "azure_sku" {
    type = string
}

variable "ghes_version" {
}

variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
}
