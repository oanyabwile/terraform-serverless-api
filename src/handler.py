import json
import os
import uuid
import boto3
from datetime import datetime

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])


def lambda_handler(event, context):
    method = event.get("httpMethod")

    if method == "POST":
        body = json.loads(event.get("body", "{}"))

        item = {
            "id": str(uuid.uuid4()),
            "title": body.get("title", ""),
            "description": body.get("description", ""),
            "created_at": datetime.utcnow().isoformat()
        }

        table.put_item(Item=item)

        return {
            "statusCode": 201,
            "body": json.dumps(item)
        }

    return {
        "statusCode": 400,
        "body": json.dumps({"message": "Unsupported method"})
    }
