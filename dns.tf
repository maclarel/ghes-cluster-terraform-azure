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