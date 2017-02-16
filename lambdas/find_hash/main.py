import boto3
import json
import uuid


def main(event, context):
    idx = str(uuid.uuid4())
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('tasks')
    table.put_item(Item={
        'ID': idx,
        'status': 'pending'
    })
    h = event['hash']
    task = {
        "hash_target": h,
        "chain_len": 666,
        "hash_f": "md5",
        "reduc_f": "naive_random",
        "alphabet": "qwertyuioplkjhgfdsazxcvbnm",
        "max_word_len": 5,
        'tid': idx
    }
    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName='rcha-queue-seekerz')
    queue.send_message(MessageBody=json.dumps(task))
    return {'id': idx}
