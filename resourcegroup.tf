# Create resource group

resource "azurerm_resource_group" "rg" {
    name     = "${var.cluster_name}_cluster_rg"
    location = var.location

    tags = {
        Environment = "GitHub Enterprise Server"
        Creator = var.creator
    }
}