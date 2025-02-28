provider "azurerm" {
  features {}
  subscription_id = ""
}

resource "azurerm_resource_group" "ingesoft5-rg" {
  name     = var.ingesoft5-rg-name
  location = var.ingesoft5-location
}

resource "azurerm_servicebus_namespace" "ingesoft5-servicebus" {
  name                = var.ingesoft5-service-bus-name
  location            = azurerm_resource_group.ingesoft5-rg.location
  resource_group_name = azurerm_resource_group.ingesoft5-rg.name
  sku                 = "Standard"

  tags = {
    environment = "academic-icesi"
  }
}

# Based on service bus,  define a asynchronous queue 

resource "azurerm_servicebus_queue" "ingesoft5-servicebus-queue" {


  name = var.ingesoft5-queue-name

  namespace_id = azurerm_servicebus_namespace.ingesoft5-servicebus.id

}

# Authorization on service bus queue

resource "azurerm_servicebus_queue_authorization_rule" "ingesoft5-service-bus-queue-rule" {

  name     = var.ingesoft5-queue-rule-name
  queue_id = azurerm_servicebus_queue.ingesoft5-servicebus-queue.id
  listen   = true
  send     = true
  manage   = false

}