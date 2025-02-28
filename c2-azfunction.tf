resource "azurerm_storage_account" "sa" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.ingesoft5-rg.name
  location                 = azurerm_resource_group.ingesoft5-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_service_plan" "sp" {
  name                = var.plan_name
  resource_group_name = azurerm_resource_group.ingesoft5-rg.name
  location            = azurerm_resource_group.ingesoft5-rg.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "wfa" {
  name                = var.wfa_name
  resource_group_name = azurerm_resource_group.ingesoft5-rg.name
  location            = azurerm_resource_group.ingesoft5-rg.location

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.sp.id

  app_settings = {
    "AzureWebJobsServiceBus" = azurerm_servicebus_namespace.ingesoft5-servicebus.default_primary_connection_string
  }

  site_config {
    application_stack {
      node_version = "~18"
    }
  }
}

resource "azurerm_function_app_function" "servicebus_trigger" {
  name            = var.name_function
  function_app_id = azurerm_windows_function_app.wfa.id
  language        = "Javascript"


  file {
    name    = "index.js"
    content = file("code/index.js")
  }

  config_json = jsonencode({
    "bindings" : [
      {
        "type" : "serviceBusTrigger",
        "direction" : "in",
        "name" : "queueItem",
        "queueName" : azurerm_servicebus_queue.ingesoft5-servicebus-queue.name,
        "connection" : "AzureWebJobsServiceBus"
      }
    ]
  })
}