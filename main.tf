# Configure the Azure provider

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create resource group

resource "azurerm_resource_group" "rg" {
    name     = "${var.cluster_name}_cluster_rg"
    location = var.location

    tags = {
        Environment = "GitHub Enterprise Server"
        Creator = var.creator
    }
}

# Create a virtual network/subnet

resource "azurerm_virtual_network" "vnet" {
    name                = "${var.cluster_name}_Vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.cluster_name}_Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Network Security Group and rule for GHES client/admin ports

resource "azurerm_network_security_group" "NSG" {
  name                = "${var.cluster_name}_NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "ghes_30_client_ports"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22","80","122","443","8080","8443","9418"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create public IPs for each VM

resource "azurerm_public_ip" "data_0_publicip" {
  name                = "data_0_PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = var.azure_sku
}

resource "azurerm_public_ip" "data_1_publicip" {
  name                = "data_1_PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = var.azure_sku
}

resource "azurerm_public_ip" "data_2_publicip" {
  name                = "data_2_PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = var.azure_sku
}

resource "azurerm_public_ip" "app_0_publicip" {
  name                = "app_0_PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = var.azure_sku
}

resource "azurerm_public_ip" "app_1_publicip" {
  name                = "app_1_PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = var.azure_sku
}

# Create network interfaces for each VM

resource "azurerm_network_interface" "data_0_nic" {
  name                      = "data_0_NIC"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "data_0_NICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.data_0_publicip.id
  }
}

resource "azurerm_network_interface" "data_1_nic" {
  name                      = "data_1_NIC"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "data_1_NICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.data_1_publicip.id
  }
}

resource "azurerm_network_interface" "data_2_nic" {
  name                      = "data_2_NIC"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "data_2_NICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.data_2_publicip.id
  }
}

resource "azurerm_network_interface" "app_0_nic" {
  name                      = "app_0_NIC"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "app_0_NICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.app_0_publicip.id
  }
}

resource "azurerm_network_interface" "app_1_nic" {
  name                      = "app_1_NIC"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "app_1_NICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.app_1_publicip.id
  }
}

# Associate NICs to NSG

resource "azurerm_network_interface_security_group_association" "app_0_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.app_0_nic.id
  network_security_group_id     = azurerm_network_security_group.NSG.id
}

resource "azurerm_network_interface_security_group_association" "app_1_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.app_1_nic.id
  network_security_group_id     = azurerm_network_security_group.NSG.id
}

resource "azurerm_network_interface_security_group_association" "data_0_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.data_0_nic.id
  network_security_group_id     = azurerm_network_security_group.NSG.id
}

resource "azurerm_network_interface_security_group_association" "data_1_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.data_1_nic.id
  network_security_group_id     = azurerm_network_security_group.NSG.id
}

resource "azurerm_network_interface_security_group_association" "data_2_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.data_2_nic.id
  network_security_group_id     = azurerm_network_security_group.NSG.id
}

# Create VMs

resource "azurerm_virtual_machine" "app_0" {
  name                  = "${var.cluster_name}_app_0"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.app_0_nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.cluster_name}_app_0_root_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 200
  }

  storage_data_disk {
    name              = "${var.cluster_name}_app_0_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 100
    lun               = 10
  }

  storage_image_reference {
    publisher = "GitHub"
    offer     = "GitHub-Enterprise"
    sku       = "GitHub-Enterprise"
    version   = var.ghes_version
  }

  os_profile {
    computer_name  = "${var.cluster_name}-app-0"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "app_1" {
  name                  = "${var.cluster_name}_app_1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.app_1_nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.cluster_name}_app_1_root_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 200
  }

  storage_data_disk {
    name              = "${var.cluster_name}_app_1_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 100
    lun               = 10
  }

  storage_image_reference {
    publisher = "GitHub"
    offer     = "GitHub-Enterprise"
    sku       = "GitHub-Enterprise"
    version   = var.ghes_version
  }

  os_profile {
    computer_name  = "${var.cluster_name}-app-1"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "data_0" {
  name                  = "${var.cluster_name}_data_0"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.data_0_nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.cluster_name}_data_0_root_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 200
  }

  storage_data_disk {
    name              = "${var.cluster_name}_data_0_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 100
    lun               = 10
  }

  storage_image_reference {
    publisher = "GitHub"
    offer     = "GitHub-Enterprise"
    sku       = "GitHub-Enterprise"
    version   = var.ghes_version
  }

  os_profile {
    computer_name  = "${var.cluster_name}-data-0"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "data_1" {
  name                  = "${var.cluster_name}_data_1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.data_1_nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.cluster_name}_data_1_root_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 200
  }

  storage_data_disk {
    name              = "${var.cluster_name}_data_1_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 100
    lun               = 10
  }

  storage_image_reference {
    publisher = "GitHub"
    offer     = "GitHub-Enterprise"
    sku       = "GitHub-Enterprise"
    version   = var.ghes_version
  }

  os_profile {
    computer_name  = "${var.cluster_name}-data-1"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "data_2" {
  name                  = "${var.cluster_name}_data_2"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.data_2_nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.cluster_name}_data_2_root_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 200
  }

  storage_data_disk {
    name              = "${var.cluster_name}_data_2_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 100
    lun               = 10
  }

  storage_image_reference {
    publisher = "GitHub"
    offer     = "GitHub-Enterprise"
    sku       = "GitHub-Enterprise"
    version   = var.ghes_version
  }

  os_profile {
    computer_name  = "${var.cluster_name}-data-2"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Create load balancer

resource "azurerm_public_ip" "lb_publicip" {
  name                = "${var.cluster_name}_lb_PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = var.azure_sku
}

resource "azurerm_lb" "lb" {
  name                          = "${var.cluster_name}_lb"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  sku                           = var.azure_sku

  frontend_ip_configuration {
    name                 = "${var.cluster_name}_lb_public_ip"
    public_ip_address_id = azurerm_public_ip.lb_publicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name                      = "${var.cluster_name}_lb_backend_address_pool"
  loadbalancer_id           = azurerm_lb.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_pool_assoc_app_0" {
  network_interface_id    = azurerm_network_interface.app_0_nic.id
  ip_configuration_name   = "app_0_NICConfg"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_pool_assoc_app_1" {
  network_interface_id    = azurerm_network_interface.app_1_nic.id
  ip_configuration_name   = "app_1_NICConfg"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

# Create load balancer health probe

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.cluster_name}_cluster_health_probe"
  port                = 443
}

# Create Load Balancer Rules

resource "azurerm_lb_rule" "lb_rule_TCP_22" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LB_TCP_22"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "${var.cluster_name}_lb_public_ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_lb_rule" "lb_rule_TCP_80" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LB_TCP_80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.cluster_name}_lb_public_ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_lb_rule" "lb_rule_TCP_122" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LB_TCP_122"
  protocol                       = "Tcp"
  frontend_port                  = 122
  backend_port                   = 122
  frontend_ip_configuration_name = "${var.cluster_name}_lb_public_ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_lb_rule" "lb_rule_TCP_443" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LB_TCP_443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${var.cluster_name}_lb_public_ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_lb_rule" "lb_rule_TCP_8080" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LB_TCP_8080"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "${var.cluster_name}_lb_public_ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_lb_rule" "lb_rule_TCP_8443" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LB_TCP_8443"
  protocol                       = "Tcp"
  frontend_port                  = 8443
  backend_port                   = 8443
  frontend_ip_configuration_name = "${var.cluster_name}_lb_public_ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_lb_rule" "lb_rule_TCP_9418" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LB_TCP_9418"
  protocol                       = "Tcp"
  frontend_port                  = 9418
  backend_port                   = 9418
  frontend_ip_configuration_name = "${var.cluster_name}_lb_public_ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

# Create DNS Zone & CNAME/A Record

resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_cname_record" "cname" {
  name                = "cname"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = "tsamcluster.net"
}

resource "azurerm_dns_a_record" "a_record" {
  name                = var.cluster_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.lb_publicip.id
}

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
  value       = "${data.azurerm_public_ip.data_0_public_ip.ip_address} ${var.cluster_name}.${var.domain}"
}
