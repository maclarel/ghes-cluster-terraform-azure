# Set up data sources

data "azurerm_public_ip" "lb_public_ip" {
  name                = "${var.cluster_name}_lb_PublicIP"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_public_ip.lb_publicip
  ]
}

data "azurerm_public_ip" "data_0_public_ip" {
  name                = "data_0_PublicIP"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_public_ip.data_2_publicip
  ]
}

data "azurerm_network_interface" "app_0_nic" {
  name                = "app_0_nic"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_network_interface.app_0_nic
  ]
}

data "azurerm_network_interface" "app_1_nic" {
  name                = "app_1_nic"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_network_interface.app_1_nic
  ]
}

data "azurerm_network_interface" "data_0_nic" {
  name                = "data_0_nic"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_network_interface.data_0_nic
  ]
}

data "azurerm_network_interface" "data_1_nic" {
  name                = "data_1_nic"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_network_interface.data_1_nic
  ]
}

data "azurerm_network_interface" "data_2_nic" {
  name                = "data_2_nic"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_network_interface.data_2_nic
  ]
}

# Create output

output "app_0_private_ip_address" {
  description = "app_0 private IP"
  value       = data.azurerm_network_interface.app_0_nic.private_ip_address
}

output "app_1_private_ip_address" {
  description = "app_1 private IP"
  value       = data.azurerm_network_interface.app_1_nic.private_ip_address
}

output "data_0_private_ip_address" {
  description = "data_0 (MySQL Master) private IP"
  value       = data.azurerm_network_interface.data_0_nic.private_ip_address
}

output "data_1_private_ip_address" {
  description = "data_1 private IP"
  value       = data.azurerm_network_interface.data_1_nic.private_ip_address
}

output "data_2_private_ip_address" {
  description = "data_2 private IP"
  value       = data.azurerm_network_interface.data_2_nic.private_ip_address
}

output "lb_url" {
  description = "Load balancer public IP"
  value       = "https://${data.azurerm_public_ip.lb_public_ip.ip_address}/"
}

output "initial_setup_url" {
  description = "Access this URL to start initial setup"
  value       = "https://${data.azurerm_public_ip.data_0_public_ip.ip_address}:8443/"
}

output "add_to_etc_hosts" {
  description = "Value to add to /etc/hosts to account for Azure DNS"
  value       = "${data.azurerm_public_ip.lb_public_ip.ip_address} ${var.cluster_name}.${var.domain}"
}
