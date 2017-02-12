import os
import redis

KEY_PREFIX = 'rainbow'


class DB(object):

    def __init__(self):
        host = os.environ['DB_HOST']
        port = os.environ['DB_PORT']
        self.db = redis.StrictRedis(host=host, port=port, db=0)
        self.params = {}

    def set_rainbow_parameters(self, chain_len, hash_f, reduc_f,
                               alphabet, max_word_len):
        self.params = {
            'l': chain_len,
            'h': hash_f,
            'r': reduc_f,
            'a': alphabet,
            'w': max_word_len
        }

    def construct_key(self, key):
        return ':'.join([KEY_PREFIX, key, str(self.params)])

    def exists(self, key):
        db_key = self.construct_key(key)
        return self.db.exists(db_key)

    def get(self, key):
        db_key = self.construct_key(key)
        return self.db.get(db_key)

    def set(self, key, value):
        db_key = self.construct_key(key)
        return self.db.set(db_key, value)
