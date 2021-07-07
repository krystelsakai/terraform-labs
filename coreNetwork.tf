resource "azurerm_resource_group" "core" {
   name         = "krystel-core-lab"
   location     = "${var.loc}"
   tags         = "${var.tags}"
}

resource "azurerm_public_ip" "pip" {
  name                = "vpnGatewayPublicIp"
  resource_group_name = "${azurerm_resource_group.core.name}"
  location            = "${var.loc}"
  tags                = "${var.tags}"
  
  allocation_method   = "Dynamic"
  
}

resource "azurerm_virtual_network" "vnet" {
  name                = "core"
  location            = "${var.loc}"
  resource_group_name = "${azurerm_resource_group.core.name}"
  tags                = "${var.tags}"

  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]

}

resource "azurerm_subnet" "gwsubnet" {
  name                 = "gatewaysubnet"
  resource_group_name  = "${azurerm_resource_group.core.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "training" {
  name                 = "training"
  resource_group_name  = "${azurerm_resource_group.core.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "dev" {
  name                 = "dev"
  resource_group_name  = "${azurerm_resource_group.core.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["10.0.2.0/24"]
}

/*
resource "azurerm_virtual_network_gateway" "vpnGateway" {
  name                = "vpnGateway"
  location            = "${var.loc}"
  resource_group_name = "${azurerm_resource_group.core.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  enable_bgp    = true
  sku           = "Basic"

  ip_configuration {
    name                          = "vpnGwConfig1"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.gwsubnet.id}"
  }
}
*/