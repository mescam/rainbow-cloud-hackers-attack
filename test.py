import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('test')

print table

entry = str(uuid.uuid1())

table.put_item(
	Item={
        'Key': 'test',
        'Start': entry
    }
)

response = table.get_item(
    Key={
        'Key': 'test'
    }
)
item = response
print(item)