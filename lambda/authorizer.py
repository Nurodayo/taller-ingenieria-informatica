import os

TOKEN = os.environ["API_TOKEN"]

def lambda_handler(event, context):
    token = event.get("headers", {}).get("authorization", "")

    return {
        "isAuthorized": token == TOKEN,
        "context": {}
    }
