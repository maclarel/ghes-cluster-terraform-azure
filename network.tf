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
