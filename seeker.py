import boto3
import json

from utils import hashers, reductors, DEFAULT_ALPHABET
from db import DB

q_name = 'rcha-queue-seekerz'
db = DB('rainbows')


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
    if '' not in alphabet:
        alphabet.append('')

    # firstly, find the chain which contains the password
    found = False
    for i in xrange(chain_len):
        hashed = hash_target
        for j in xrange(i, chain_len):
            if db.exists(hashed):
                found = True
                start_word = db.get(hashed)
                break
            password = reduc_f(hashed, alphabet, max_word_len, j)
            hashed = hash_f(password)
        if found:
            break

    # if you somehow didn't manage to find the chain...
    if not found:
        return None

    # secondly, given the chain's starting word, regenerate it to find ur pass
    password = start_word
    for i in xrange(chain_len):
        hashed = hash_f(password)
        if hashed == hash_target:
            return password
        password = reduc_f(hashed, alphabet, max_word_len, i)

    return None, "I found the chain but the password wasn't there. WTF :("


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
