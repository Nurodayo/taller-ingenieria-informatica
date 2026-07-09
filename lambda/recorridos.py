import os
import boto3
import json
import uuid

## No se si utilizaremos todos los endpoints pero estan alli por si acaso
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["RESERVAS_TABLE"])

def recorridos_handler(event):
    method = event["requestContext"]["http"]["method"]

    if method == "POST":
        return crear_recorrido(event)
    elif method == "GET":
        return get_recorrido(event)
    elif method == "PUT":
        return modificar_recorrido(event)
    elif method == "DELETE":
        return delete_recorrido(event)

def crear_recorrido(event):
    try:
        body = json.loads(event["body"])

        item = {
            "id": str(uuid.uuid4()),
            "nombre": body["nombre"],
            "hora": body["hora"],
            "cupos": body["cupos"],
            "precio": body["precio"],
            "chofer": body["chofer"],
            "from": body["from"],
            "to": body["to"]
        }

        table.put_item(Item=item)

        return {
            "statusCode": 201,
            "body": json.dumps(item)
        }
    except Exception as e:
        print(e)
        return{
            "statusCode": 500,
            "body": json.dumps({"error": "no se pudo crear el recorrido"})
        }



def get_recorrido(event):
    try:
        response = table.scan()
        items = response.get("Items", [])

        return {
            "statusCode": 200,
            "body": json.dumps(items)
        }
    except Exception as e:
        print(e)
        return{
            "statusCode": 500,
            "body": json.dumps({"error": "no se pudieron obtener recorridos"})
        }


def delete_recorrido(event):
    try:
        id = event["pathParameters"]["id"]

        table.delete_item(
            Key={"id": id},
            ConditionExpression="attribute_exists(id)"
                        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "recorrido eliminado"})
        }
    except Exception as e:
        print(e)
        return{
            "statusCode": 404,
            "body": json.dumps({"error": "recorrido no encontrado"})
        }


def modificar_recorrido(event):
    try:
        body = json.loads(event["body"])
        id = event["pathParameters"]["id"]

        item = table.update_item(
            Key={"id": id},
            UpdateExpression="SET nombre = :n, fecha = :h, cupos = :c, precio = :p, chofer = :cf, from = :f, to =:t",
            ExpressionAttributeValues={
            ":n": body["nombre"],
            ":h": body["hora"],
            ":c": body["cupos"],
            ":p": body["precio"],
            ":cf": body["chofer"],
            ":f": body["from"],
            ":t": body["to"]
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
            "body": json.dumps({"error": "recorrido no encontrado"})
        }


