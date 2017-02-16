resource "aws_s3_bucket" "lambdas" {
    bucket = "rcha-lambda"

    tags {
        Name = "Lambda code"
        Service = "RainbowCloudHackersAttack"
    }
}

resource "aws_s3_bucket" "tf" {
    bucket = "rcha-terraform"

    tags {
        Name = "TF state"
        Service = "RainbowCloudHackersAttack"
    }
}
