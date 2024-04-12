import boto3 
import json
import os
import uuid

def lambda_handler(event, context):
    try:
        # Retrieve environment variables
        dynamodb_table_name = os.environ.get('DYNAMODB_TABLE')
        email = os.environ.get('EMAIL')
        
        # Check if required environment variables are set
        if not dynamodb_table_name or not email:
            raise ValueError("Missing required environment variables.")
        
        # Initialize DynamoDB resource
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(dynamodb_table_name)
        
        # Generate unique ID for the item
        item_id = str(uuid.uuid4())
        
        # Add item to DynamoDB table
        response = table.put_item(Item={
            'id': item_id,
            'Email': email,
            'RequestEventData': event
        })
        
        # Return success response
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Item added to DynamoDB table successfully.",
                "itemId": item_id
            })
        }
    except Exception as e:
        # Log error
        print(f"Error: {str(e)}")
        
        # Return error response
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": "Internal Server Error"
            })
        }