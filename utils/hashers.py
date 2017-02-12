import hashlib


def available():
    return ['md5', 'sha256']


def md5(word):
    return hashlib.md5(word).hexdigest()


def sha256(word):
    return hashlib.sha256(word).hexdigest()
