import boto3


def extract(x):
    return {
        'name': x['AutoScalingGroupName'],
        'min': x['MinSize'],
        'max': x['MaxSize'],
        'desired': x['DesiredCapacity']
    }


def main(event, context):
    client = boto3.client('autoscaling')
    asgs = client.describe_auto_scaling_groups(
        AutoScalingGroupNames=['rcha-seekerz-asg', 'rcha-hackerz-asg']
    )
    return map(extract, asgs['AutoScalingGroups'])
