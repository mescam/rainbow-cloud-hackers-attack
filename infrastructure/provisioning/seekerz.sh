#!/bin/bash

export AWS_DEFAULT_REGION=eu-west-1
apt-get update
apt-get install -y python-minimal python-pip git
pip install awscli boto3

git clone https://github.com/mescam/rainbow-cloud-hackers-attack.git
cd rainbow-cloud-hackers-attack

python seeker.py &> /tmp/seekerz.log
poweroff