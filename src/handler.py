import json
import os
import uuid
from datetime import datetime
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])


def lambda_handler(event, context):
    method = event["httpMethod"]
    path = event["resource"]

    # POST /tasks
    if method == "POST" and path == "/tasks":
        body = json.loads(event.get("body", "{}"))

        item = {
            "id": str(uuid.uuid4()),
            "title": body.get("title"),
            "description": body.get("description"),
            "created_at": datetime.utcnow().isoformat()
        }

        table.put_item(Item=item)

        return response(200, item)

    # GET /tasks
    if method == "GET" and path == "/tasks":
        result = table.scan()
        return response(200, result.get("Items", []))

    # GET /tasks/{id}
    if method == "GET" and path == "/tasks/{id}":
        task_id = event["pathParameters"]["id"]

        result = table.get_item(Key={"id": task_id})
        item = result.get("Item")

        if not item:
            return response(404, {"message": "Task not found"})

        return response(200, item)

    # DELETE /tasks/{id}
    if method == "DELETE" and path == "/tasks/{id}":
        task_id = event["pathParameters"]["id"]

        table.delete_item(Key={"id": task_id})
        return response(200, {"message": "Task deleted"})

    return response(400, {"message": "Unsupported method"})


def response(status, body):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }
