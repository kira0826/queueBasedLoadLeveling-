module.exports = async function (context, queueItem) {
    context.log('Mensaje recibido desde Service Bus Queue:', queueItem);

    context.res = {
        status: 200,
        body: `Mensaje recibido: ${JSON.stringify(queueItem)}`
    };
};
