import boto3 
import json
import os
import uuid
import datetime

def lambda_handler(event, context):
    # Retrieve the DynamoDB table name from environment variables
    dynamodb_table_name = os.environ.get('DYNAMODB_TABLE')
    
    # Initialize the DynamoDB resource
    dynamodb = boto3.resource('dynamodb')
    
    # Access the DynamoDB table
    table = dynamodb.Table(dynamodb_table_name)
    
    # Extract user agent from request headers
    user_agent = event.get('headers', {}).get('User-Agent', 'Unknown')
    
    # Construct data to be inserted into DynamoDB
    data = {
        'id': str(uuid.uuid4()),  # Generate a unique ID for the record
        'timestamp': datetime.datetime.now().isoformat(),  # Get current timestamp in ISO format
        'user_agent': user_agent  # Store user agent
    }

    # Insert data into DynamoDB table
    response = table.put_item(Item=data)

    # Return successful response
    return {"statusCode": 200, "body": json.dumps(event)}
