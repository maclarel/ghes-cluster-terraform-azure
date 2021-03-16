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

resource "azurerm_lb_probe" "lb_probe_443" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.cluster_name}_cluster_health_probe_443"
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
  probe_id                       = azurerm_lb_probe.lb_probe_443.id
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
