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
    name     = "ghes_30_cluster_rg"
    location = var.location

    tags = {
        Environment = "GitHub Enterprise Server"
    }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "ghes_30_Vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "ghes_30_Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Network Security Group and rule for GHES client ports
resource "azurerm_network_security_group" "ghes_30_NSG" {
  name                = "ghes_30_NSG"
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
  network_security_group_id     = azurerm_network_security_group.ghes_30_NSG.id
}

resource "azurerm_network_interface_security_group_association" "app_1_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.app_1_nic.id
  network_security_group_id     = azurerm_network_security_group.ghes_30_NSG.id
}

resource "azurerm_network_interface_security_group_association" "data_0_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.data_0_nic.id
  network_security_group_id     = azurerm_network_security_group.ghes_30_NSG.id
}

resource "azurerm_network_interface_security_group_association" "data_1_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.data_1_nic.id
  network_security_group_id     = azurerm_network_security_group.ghes_30_NSG.id
}

resource "azurerm_network_interface_security_group_association" "data_2_nic_nsg_assoc" {
  network_interface_id          = azurerm_network_interface.data_2_nic.id
  network_security_group_id     = azurerm_network_security_group.ghes_30_NSG.id
}

# Create VMs

resource "azurerm_virtual_machine" "ghes_30_data_0" {
  name                  = "ghes_30_data_0"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.data_0_nic.id]
  vm_size               = "Standard_DS12_v2"

  storage_os_disk {
    name              = "ghes_30_data_0_root_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 200
  }

  storage_data_disk {
    name              = "ghes_30_data_0_data_disk"
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
    computer_name  = "ghes-30-data-0"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Create load balancer

resource "azurerm_public_ip" "ghes_30_lb_publicip" {
  name                = "ghes_30_lb_PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = var.azure_sku
}

resource "azurerm_lb" "ghes_30_lb" {
  name                          = "ghes_30_lb"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  sku                           = var.azure_sku

  frontend_ip_configuration {
    name                 = "ghes_30_lb_public_ip"
    public_ip_address_id = azurerm_public_ip.ghes_30_lb_publicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "ghes_30_lb_backend_address_pool" {
  name                      = "ghes_30_lb_backend_address_pool"
  loadbalancer_id           = azurerm_lb.ghes_30_lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "ghes_30_lb_pool_assoc_app_0" {
  network_interface_id    = azurerm_network_interface.app_0_nic.id
  ip_configuration_name   = "app_0_NICConfg"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ghes_30_lb_backend_address_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "ghes_30_lb_pool_assoc_app_1" {
  network_interface_id    = azurerm_network_interface.app_1_nic.id
  ip_configuration_name   = "app_1_NICConfg"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ghes_30_lb_backend_address_pool.id
}

# Create load balancer health probe

resource "azurerm_lb_probe" "ghes_30_lb_probe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.ghes_30_lb.id
  name                = "ghes_30_cluster_health_probe"
  port                = 443
}

# Create Load Balancer Rules

resource "azurerm_lb_rule" "ghes_30_lb_rule_TCP_22" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.ghes_30_lb.id
  name                           = "LB_TCP_22"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "ghes_30_lb_public_ip"
}

resource "azurerm_lb_rule" "ghes_30_lb_rule_TCP_80" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.ghes_30_lb.id
  name                           = "LB_TCP_80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "ghes_30_lb_public_ip"
}

resource "azurerm_lb_rule" "ghes_30_lb_rule_TCP_122" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.ghes_30_lb.id
  name                           = "LB_TCP_122"
  protocol                       = "Tcp"
  frontend_port                  = 122
  backend_port                   = 122
  frontend_ip_configuration_name = "ghes_30_lb_public_ip"
}

resource "azurerm_lb_rule" "ghes_30_lb_rule_TCP_443" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.ghes_30_lb.id
  name                           = "LB_TCP_443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "ghes_30_lb_public_ip"
}

resource "azurerm_lb_rule" "ghes_30_lb_rule_TCP_8080" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.ghes_30_lb.id
  name                           = "LB_TCP_8080"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "ghes_30_lb_public_ip"
}

resource "azurerm_lb_rule" "ghes_30_lb_rule_TCP_8443" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.ghes_30_lb.id
  name                           = "LB_TCP_8443"
  protocol                       = "Tcp"
  frontend_port                  = 8443
  backend_port                   = 8443
  frontend_ip_configuration_name = "ghes_30_lb_public_ip"
}

resource "azurerm_lb_rule" "ghes_30_lb_rule_TCP_9418" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.ghes_30_lb.id
  name                           = "LB_TCP_9418"
  protocol                       = "Tcp"
  frontend_port                  = 9418
  backend_port                   = 9418
  frontend_ip_configuration_name = "ghes_30_lb_public_ip"
}

# Create DNS Zone & CNAME & A Record

resource "azurerm_dns_zone" "ghes_30_dns_zone" {
  name                = "tsamcluster.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_cname_record" "cname" {
  name                = "cname"
  zone_name           = azurerm_dns_zone.ghes_30_dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = "tsamcluster.net"
}

resource "azurerm_dns_a_record" "example" {
  name                = "30"
  zone_name           = azurerm_dns_zone.ghes_30_dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.ghes_30_lb_publicip.id
}
