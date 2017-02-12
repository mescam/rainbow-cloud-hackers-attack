provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_key_pair" "master" {
  key_name = "RCHA-MasterKey" 
  public_key = "${var.aws_key}"
}