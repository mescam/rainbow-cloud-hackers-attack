import boto3
import json

from utils import hashers, reductors, DEFAULT_ALPHABET
from db import DB

q_name = 'rcha-queue-hackerz'
db = DB('rainbows')


def generate(chain_len, hash_f, reduc_f, alphabet, max_word_len, start_word):
    db.set_rainbow_parameters(
        chain_len, hash_f, reduc_f, alphabet, max_word_len)
    if hash_f not in hashers.available():
        raise NameError("Hashing function not found")
    hf = getattr(hashers, hash_f)
    if reduc_f not in reductors.available():
        raise NameError("Reduction function not found")
    rf = getattr(reductors, reduc_f)
    if len(start_word) > max_word_len:
        raise ValueError("Starting word can't be longer than the max_word_len")

    alphabet = list(alphabet)

    password = start_word
    for i in xrange(chain_len):
        hashed = hf(password)
        password = rf(hashed, alphabet, max_word_len, i)
    db.set(hashed, start_word)
    return start_word, hashed


if __name__ == '__main__':
    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName=q_name)

    while True:
        for msg in queue.receive_messages(
            MessageAttributeNames=[
                'string',
            ],
            MaxNumberOfMessages=1,
            VisibilityTimeout=100,
            WaitTimeSeconds=5
        ):
            print generate(**json.loads(msg.body))
            msg.delete()
