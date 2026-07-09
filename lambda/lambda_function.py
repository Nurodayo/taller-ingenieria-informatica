from reservas import reservas_handler
from recorridos import recorridos_handler

def lambda_handler(event, context):
    path = event["requestContext"]["http"]["path"]

    if path.startswith("/reservas"):
        return reservas_handler(event)

    if path.startswith("/recorridos"):
        return recorridos_handler(event)

    return {
        "statusCode": 404,
        "body": "Ruta no encontrada"
    }
