import os
import boto3
import json
import uuid

## No se si utilizaremos todos los endpoints pero estan alli por si acaso
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["RESERVAS_TABLE"])
recorridos_table = dynamodb.Table(os.environ["RECORRIDOS_TABLE"])


def reservas_handler(event):
    method = event["requestContext"]["http"]["method"]

    if method == "POST":
        return crear_reserva(event)
    elif method == "GET":
        return get_reserva(event)
    elif method == "PUT":
        return modificar_reserva(event)
    elif method == "DELETE":
        return delete_reserva(event)

def crear_reserva(event):
    try:
        body = json.loads(event["body"])

        item = {
            "id": str(uuid.uuid4()),
            "nombre": body["nombre"],
            "correo": body["correo"],
            "fecha": body["fecha"],
            "Asientos": body["Asientos"],
            "recorrido": body["recorrido"]
        }

        recorrido = recorridos_table.get_item(
            Key={"id": body["recorrido"]}
        )
        recorrido = recorrido.get("Item")

        ## Valudacion de asientos
        if body["Asientos"] > recorrido["cupos"]:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "No hay suficientes cupos"})
            }

        if not recorrido:
            return {
                "statusCode": 404,
                "body": json.dumps({"error": "Recorrido no encontrado"})
            }


        ## POST

        table.put_item(Item=item)

        return {
            "statusCode": 201,
            "body": json.dumps(item)
        }
    except Exception as e:
        print(e)
        return{
            "statusCode": 500,
            "body": json.dumps({"error": "no se pudo crear la reserva"})
        }

## Algo que podria fallar es que hayan tantas reservas o recorridos que al hacer get/ hayan demasiados objetos que colapse, es una demostracion no pasara

def get_reserva(event):
    try:
        path_params = event.get("pathParameters")

        if path_params and path_params.get("id"):
            response = table.get_item(
                Key={
                    "id": path_params["id"]
                }
            )

            item = response.get("Item")

            if not item:
                return {
                    "statusCode": 404,
                    "body": json.dumps({"error": "Reserva no encontrada"})
                }

            return {
                "statusCode": 200,
                "body": json.dumps(item, default=int)
            }

        ## GET reservas/ para posible admin panel

        response = table.scan()
        items = response.get("Items", [])

        return {
            "statusCode": 200,
            "body": json.dumps(items, default=int)
        }
    except Exception as e:
        print(e)
        return{
            "statusCode": 500,
            "body": json.dumps({"error": "no se pudieron obtener reservas"})
        }

def delete_reserva(event):
    try:
        id = event["pathParameters"]["id"]

        table.delete_item(
            Key={"id": id},
            ConditionExpression="attribute_exists(id)"
                        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "reserva eliminada"})
        }
    except Exception as e:
        print(e)
        return{
            "statusCode": 404,
            "body": json.dumps({"error": "reserva no encontrada"})
        }


def modificar_reserva(event):
    try:
        existe = get_reserva(event)

        if existe["statusCode"] == 404:
            raise Exception("Aparentemente si intentas modifcar un objeto que no existe crea uno nuevo en vez de tirar error")

        body = json.loads(event["body"])
        id = event["pathParameters"]["id"]

        item = table.update_item(
        Key={"id": id},
        ## No se updateara la cantidad de asientos
        UpdateExpression="SET nombre = :n, correo = :c, fecha = :f, recorrido = :r",
        ExpressionAttributeValues={
        ":n": body["nombre"],
        ":c": body["correo"],
        ":f": body["fecha"],
        ":r": body["recorrido"] 
        },
        ReturnValues="ALL_NEW"
        )
        return {
            "statusCode": 200,
            "body": json.dumps(item["Attributes"])
        }

    except Exception as e:
        print(e)
        return{
            "statusCode": 404,
            "body": json.dumps({"error": "reserva no encontrada"})
        }


