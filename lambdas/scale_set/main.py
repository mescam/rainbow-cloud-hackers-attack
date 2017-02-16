import boto3


def main(event, context):
    client = boto3.client('autoscaling')
    if event['name'] not in ['rcha-seekerz-asg', 'rcha-hackerz-asg']:
        return {'error': 'no hacking plz'}
    client.set_desired_capacity(
        AutoScalingGroupName=event['name'],
        DesiredCapacity=event['capacity'],
    )
    return {'message': 'ok'}
