import boto3
import json
import uuid


def main(event, context):
    return event
    tid = context['tid']
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('tasks')
    response = table.get_item(Key={
        'ID': tid,
    })
    if not 'result' in response['Item']:
        response['Item']['result'] == ''
    return {'status': response['Item']['status'], 'result': response['Item']['result']}
