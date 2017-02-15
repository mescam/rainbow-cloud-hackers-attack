import boto3

dynamodb = boto3.resource('dynamodb')


class DB(object):

    def __init__(self, table):
        self.table = dynamodb.Table(table)
        self.params = ''

    def set_rainbow_parameters(self, chain_len, hash_f, reduc_f,
                               alphabet, max_word_len):
        self.params = '-'.join([str(chain_len), hash_f, reduc_f,
                                alphabet, str(max_word_len)])

    def construct_key(self, key):
        return ':'.join([key, str(self.params)])

    def exists(self, key):
        response = self.table.get_item(
            Key={
                'Key': self.construct_key(key)
            }
        )
        return 'Item' in response

    def get(self, key):
        response = self.table.get_item(
            Key={
                'Key': self.construct_key(key)
            }
        )
        return response['Item']['val'] if 'Item' in response else None

    def set(self, key, value):
        self.table.put_item(
            Item={
                'Key': self.construct_key(key),
                'val': value
            }
        )

    def batch_set(self, items_dict):
        with self.table.batch_writer() as batch:
            for key in items_dict:
                batch.put_item(
                    Item={
                        'Key': self.construct_key(key),
                        'val': items_dict[key]
                    }
                )
