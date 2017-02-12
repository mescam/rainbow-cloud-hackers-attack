import random


def available():
    return ['naive_random']


def naive_random(hashed, alphabet, max_word_len, iteration_number=None):
    random.seed((hashed, iteration_number))
    res = ''
    for i in xrange(max_word_len):
        res += random.choice(alphabet)
    return res
