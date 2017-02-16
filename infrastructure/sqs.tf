resource "aws_sqs_queue" "seekerz" {
  name = "rcha-queue-seekerz"
}

resource "aws_sqs_queue" "hackerz" {
  name = "rcha-queue-hackerz"
}