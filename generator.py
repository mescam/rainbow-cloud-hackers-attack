import argparse

from utils import hashers, reductors, DEFAULT_ALPHABET
from db import DB

db = DB()


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
        # print password
        hashed = hf(password)
        password = rf(hashed, alphabet, max_word_len, i)
    db.set(hashed, start_word)
    return start_word, hashed


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
    p.add_argument('start_word', metavar='start',
                   help="password that will initialize the chain")
    p.add_argument('-a', dest='alphabet',
                   default=DEFAULT_ALPHABET,
                   help='''a limited set of characters used for
                           generating valid passwords (e.g. "-a abcd123").
                           By default it will use all printable characters''')

    args = p.parse_args()
    print generate(**vars(args))
