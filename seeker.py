import boto3
import json

from utils import hashers, reductors
from db import DB

q_name = 'rcha-queue-seekerz'
db = DB('rainbows')


def check(start_word, hash_target, chain_len,
          hash_f, reduc_f, alphabet, max_word_len):
    password = start_word
    for i in xrange(chain_len):
        hashed = hash_f(password)
        if hashed == hash_target:
            return password
        password = reduc_f(hashed, alphabet, max_word_len, i)
    return None


def seek(hash_target, chain_len, hash_f, reduc_f, alphabet, max_word_len):
    db.set_rainbow_parameters(
        chain_len, hash_f, reduc_f, alphabet, max_word_len)
    if hash_f not in hashers.available():
        raise NameError("Hashing function not found")
    hash_f = getattr(hashers, hash_f)
    if reduc_f not in reductors.available():
        raise NameError("Reduction function not found")
    reduc_f = getattr(reductors, reduc_f)

    alphabet = list(alphabet)

    false_alarms = 0
    for i in xrange(chain_len, 0, -1):
        hashed = hash_target
        for j in xrange(i - 1, chain_len - 1):
            password = reduc_f(hashed, alphabet, max_word_len, j)
            hashed = hash_f(password)
        if db.exists(hashed):
            start_word = db.get(hashed)
            res = check(start_word, hash_target, chain_len,
                        hash_f, reduc_f, alphabet, max_word_len)
            if res is not None:
                print 'False alarms: {}'.format(false_alarms)
                return res
            else:
                false_alarms += 1
    print 'NOT FOUND with false alarms: {}'.format(false_alarms)
    return None


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
            print seek(**json.loads(msg.body))
            msg.delete()
