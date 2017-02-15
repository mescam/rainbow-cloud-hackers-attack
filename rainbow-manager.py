import argparse

from utils import hashers, reductors, DEFAULT_ALPHABET
from generator import generate

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
    f_args = vars(args)
    for sw in start_words:
        f_args['start_word'] = sw
        print generate(**f_args)

    # print generate(**vars(args))
