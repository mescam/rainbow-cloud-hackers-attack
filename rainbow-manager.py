import argparse
import json
import boto3

from utils import hashers, reductors, DEFAULT_ALPHABET
from generator import generate

q_name = 'rcha-queue-hackerz'

def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    for i in xrange(0, len(l), n):
        yield l[i:i + n]


if __name__ == '__main__':
    p = argparse.ArgumentParser(description='Generate a single rainbow chain.')
    p.add_argument('chain_len', type=int,
                   help="length of the chain")
    p.add_argument('hash_f', choices=hashers.available(),
                   help="password hashing function")
    p.add_argument('reduc_f', choices=reductors.available(),
                   help='''reduction function used for
                           generating valid passwords''')
    p.add_argument('max_word_len', type=int,
                   help="maximum password length")
    p.add_argument('-a', dest='alphabet',
                   default=DEFAULT_ALPHABET,
                   help='''a limited set of characters used for
                           generating valid passwords (e.g. "-a abcd123").
                           By default it will use all printable characters''')

    args = p.parse_args()
    combinations = len(args.alphabet) ** args.max_word_len
    chains = (combinations * 2) / args.chain_len
    print 'Combinations: {}'.format(combinations)
    print 'Chains: {}'.format(chains)

    start_words = set()
    for i in xrange(chains):
        start_words.add(
            reductors.naive_random(i, args.alphabet, args.max_word_len))

    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName=q_name)

    f_args = vars(args)
    batch_size = min((len(start_words) / 4, 500))
    print 'Batch size: {}'.format(batch_size)
    for batch in chunks(list(start_words), batch_size):
        f_args['start_words'] = batch
        body = json.dumps(f_args)
        queue.send_message(MessageBody=body)
    print 'SENT!'
