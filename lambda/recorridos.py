import os
import boto3
import json
import uuid
from urllib.parse import quote_plus

## No se si utilizaremos todos los endpoints pero estan alli por si acaso
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["RECORRIDOS_TABLE"])

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
        
       
        ## Campos obligatorios de los recorridos
        campos = [
            "nombre",
            "hora",
            "cupos",
            "precio",
            "chofer",
            "from",
            "to"
        ]
     
        ## Default image

        if not body.get("image"):
            image = f"https://placehold.co/600x400?text={quote_plus(body["nombre"])}"
        elif body["image"] == "":
            image = f"https://placehold.co/600x400?text={quote_plus(body["nombre"])}"
        else:
            image = body["image"]

        ## Validacion de precios y cupos

        if body["cupos"] <= 0:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Los cupos deben ser un entero mayor que 0"})
            }

        # Validar precio
        if body["precio"] < 0:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "El precio debe ser un número mayor o igual a 0"})
            }

        ## Objeto a postear
        item = {
            "id": str(uuid.uuid4()),
            "nombre": body["nombre"],
            "hora": body["hora"],
            "cupos": body["cupos"],
            "precio": body["precio"],
            "image": image,
            "chofer": body["chofer"],
            "from": body["from"],
            "to": body["to"]
        }

        ## verificar campos obligatorios
        faltantes = [c for c in campos if c not in body]
        
        if faltantes:
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "error": f"Faltan los campos: {', '.join(faltantes)}"
                })
            }
        
        ## Imagen default 
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
                    "body": json.dumps({"error": "Recorrido no encontrado"})
                }

            return {
                "statusCode": 200,
                "body": json.dumps(item, default=int)
            }

        ## GET recorridos/

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


