resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name        = "rainbow-cloud-hackers-attack"
  }
}

resource "aws_internet_gateway" "internet-gw" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name        = "rcha-igw"
    }
}

resource "aws_route_table" "internet-rt" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internet-gw.id}"
    }
    tags {
        Name        = "rcha-irt"
    }
}

resource "aws_subnet" "hackerz-a" {
    vpc_id                  = "${aws_vpc.main.id}"
    cidr_block              = "10.10.10.0/24"
    availability_zone       = "${format("%s%s", var.aws_region, "a")}"
    map_public_ip_on_launch = true
    tags {
        Name = "hackerz-a"
    }
}

resource "aws_subnet" "hackerz-b" {
    vpc_id                  = "${aws_vpc.main.id}"
    cidr_block              = "10.10.11.0/24"
    availability_zone       = "${format("%s%s", var.aws_region, "b")}"
    map_public_ip_on_launch = true
    tags {
        Name  = "hackerz-b"
    }
}

resource "aws_subnet" "seekerz-a" {
    vpc_id                  = "${aws_vpc.main.id}"
    cidr_block              = "10.10.20.0/24"
    availability_zone       = "${format("%s%s", var.aws_region, "a")}"
    map_public_ip_on_launch = true
    tags {
        Name = "seekerz-a"
    }
}

resource "aws_subnet" "seekerz-b" {
    vpc_id                  = "${aws_vpc.main.id}"
    cidr_block              = "10.10.21.0/24"
    availability_zone       = "${format("%s%s", var.aws_region, "b")}"
    map_public_ip_on_launch = true
    tags {
        Name  = "seekerz-b"
    }
}

resource "aws_security_group" "internal" {
    name        = "allow_internal"
    description = "Allow VPC traffic"
    vpc_id      = "${aws_vpc.main.id}"
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["10.10.0.0/16"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "allow_internal"
    }
}


resource "aws_iam_instance_profile" "hackerz" {
    name  = "hackerz_iam_profile"
    roles = ["${aws_iam_role.hackerz_role.name}"]
}

resource "aws_iam_role" "hackerz_role" {
    name = "rcha-hackerz-role"
    assume_role_policy = <<EOF
{   
    "Version":"2012-10-17",
    "Statement":[{
                        "Effect":"Allow",
                        "Principal":
                        {
                            "Service":["ec2.amazonaws.com"]
                        },
                        "Action":["sts:AssumeRole"]
                }]
}
EOF
}


resource "aws_iam_instance_profile" "seekerz" {
    name  = "seekerz_iam_profile"
    roles = ["${aws_iam_role.seekerz_role.name}"]
}

resource "aws_iam_role" "seekerz_role" {
    name = "rcha-seekerz-role"
    assume_role_policy = <<EOF
{   
    "Version":"2012-10-17",
    "Statement":[{
                        "Effect":"Allow",
                        "Principal":
                        {
                            "Service":["ec2.amazonaws.com"]
                        },
                        "Action":["sts:AssumeRole"]
                }]
}
EOF
}