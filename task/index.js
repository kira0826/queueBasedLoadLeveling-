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
    await sendMessage();
  }
})();
