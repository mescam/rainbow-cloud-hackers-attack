import argparse

from utils import hashers, reductors, DEFAULT_ALPHABET


def check_in_table(hashed):
    # TODO: check in table if there is a chain ending with the given hash
    #       -> if yes: then return the word which generated the chain
    #       -> else: return None
    if hashed == 'c419b06b4c6579b50ff05adb3b8424f1':
        return 'ba'
    else:
        return None


def find(hash_target, chain_len, hash_f, reduc_f, alphabet, max_word_len):
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
    for i in xrange(chain_len):
        hashed = hash_target
        for j in xrange(i, chain_len):
            start_word = check_in_table(hashed)
            if start_word is not None:
                break
            password = reduc_f(hashed, alphabet, max_word_len, j)
            hashed = hash_f(password)
        if start_word is not None:
            break

    # if you somehow didn't manage to find the chain...
    if start_word is None:
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
    p = argparse.ArgumentParser(description='''Find given hash
                                               in a single rainbow table.''')
    p.add_argument('hash_target', metavar='hash',
                   help="hash you are trying to find")
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
    print find(**vars(args))
