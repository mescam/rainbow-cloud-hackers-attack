import boto3


def main(event, context):
    tid = event['tid']
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('tasks')
    response = table.get_item(Key={
        'ID': tid,
    })
    if 'Item' not in response:
        return {'error': 404}

    if 'result' not in response['Item']:
        response['Item']['result'] = ''
    return {'status': response['Item']['status'], 'result': response['Item']['result']}
