import boto3
import json
import time

from utils import hashers, reductors
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
    if '' not in alphabet:
        alphabet.append('')

    password = start_word
    for i in xrange(chain_len):
        hashed = hf(password)
        password = rf(hashed, alphabet, max_word_len, i)
    return hashed, start_word


if __name__ == '__main__':
    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName=q_name)

    while True:
        for msg in queue.receive_messages(
            MessageAttributeNames=[
                'string',
            ],
            MaxNumberOfMessages=1,
            VisibilityTimeout=300,
            WaitTimeSeconds=5
        ):
            start_t = time.time()
            chains = {}
            request = json.loads(msg.body)
            for start_word in request['start_words']:
                hashed, start_word = generate(
                    request['chain_len'],
                    request['hash_f'],
                    request['reduc_f'],
                    request['alphabet'],
                    request['max_word_len'],
                    start_word
                )
                chains[hashed] = start_word
            db.batch_set(chains)
            print "Requested chains: {}, Generated: {} in {}s".format(
                len(request['start_words']),
                len(chains),
                (time.time() - start_t)
            )
            msg.delete()
