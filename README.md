# Queue-Based Load Leveling with Azure and Terraform

Ricardo Urbina Ospina - A00395489
Kevin Steven Nieto Curaca - A00395466

## Overview
This project demonstrates when and how to apply the **Queue-Based Load Leveling** pattern using **Terraform** to define infrastructure as code. The main goal is to create an **Azure Function** that prints incoming messages. This function is triggered by messages arriving at our second infrastructure component: **Azure Service Bus**, which includes a **queue** that manages and routes all incoming requests.

The infrastructure is defined using Terraform, with all naming conventions stored in `.tfvars` files. The following code snippet illustrates how the Azure Function is set up to be triggered by messages from the Service Bus queue:

```hcl
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
        "queueName": azurerm_servicebus_queue.ingesoft5-servicebus-queue.name,
        "connection" : "AzureWebJobsServiceBus"
      }
    ]
  })
}  
```

## Project Structure
The project is organized into different components:
- **Infrastructure Services (`c1` and `c2` files)**: Each contains Terraform configurations for creating specific infrastructure elements.
- **`code/` folder**: Contains the JavaScript function that is deployed to the Azure Function.
- **`.tfvars` file**: Defines the values for all necessary variables (properly added to `.gitignore`).

## Message Processing
The JavaScript code connects to the Service Bus queue to send a set of messages. Each message includes the timestamp of when it was sent. These messages can be viewed in **Azure Portal's Log Stream and Function Overview**, as demonstrated in the following images:


![image](https://github.com/user-attachments/assets/e96835de-a0a6-4d8d-bf15-e303c37e0089)

![image](https://github.com/user-attachments/assets/83b61c30-d116-4531-8077-0b9732b2a42c)

![image](https://github.com/user-attachments/assets/86485b45-6e54-4944-8038-7d7231081917)


## Conclusion
With this setup, we successfully simulate the **Queue-Based Load Leveling** pattern using **Azure** infrastructure. The system consists of:
- A **JavaScript application** to send messages:

```hcl
  const { ServiceBusClient } = require("@azure/service-bus");

const connectionString =
  "Endpoint=sb://<ingesoft5-service-bus-name>.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=<PRIMARY_KEY>";
const queueName = "<ingesoft5-queue-name>";

async function sendMessage() {
  const sbClient = new ServiceBusClient(connectionString);
  const sender = sbClient.createSender(queueName);

  try {
    const message = {
      body: { text: `Hola desde Azure! ${new Date().toISOString()}` }, // Mensaje único
      contentType: "application/json",
    };

    console.log("Enviando mensaje:", message.body);
    await sender.sendMessages(message);
    console.log("✅ Mensaje enviado con éxito!");
  } catch (error) {
    console.error("❌ Error enviando mensaje:", error);
  } finally {
    await sender.close();
    await sbClient.close();
  }
}

const X = 5;

(async () => {
  for (let i = 0; i < X; i++) {
    await sendMessage(i);
  }
})();

```
- An **Azure Service Bus queue** to handle incoming requests.
- An **Azure Function** triggered by the queue.

### Architecture diagram

![image](https://github.com/user-attachments/assets/f9ecd6fe-38e3-4c8c-a7ef-c6d440b34cc0)


This approach ensures load balancing and decouples message producers from consumers, enhancing system scalability, maximize availabily, cost control and reliability.

