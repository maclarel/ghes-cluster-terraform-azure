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
    disk_size_gb      = var.root_disk_size
  }

  storage_data_disk {
    name              = "${var.cluster_name}_app_0_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = var.app_node_disk_size
    lun               = 0
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
    disk_size_gb      = var.root_disk_size
  }

  storage_data_disk {
    name              = "${var.cluster_name}_app_1_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = var.app_node_disk_size
    lun               = 0
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
    disk_size_gb      = var.root_disk_size
  }

  storage_data_disk {
    name              = "${var.cluster_name}_data_0_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = var.data_node_disk_size
    lun               = 0
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
    disk_size_gb      = var.root_disk_size
  }

  storage_data_disk {
    name              = "${var.cluster_name}_data_1_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = var.data_node_disk_size
    lun               = 0
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
    disk_size_gb      = var.root_disk_size
  }

  storage_data_disk {
    name              = "${var.cluster_name}_data_2_data_disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = var.data_node_disk_size
    lun               = 0
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