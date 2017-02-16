resource "aws_iam_role" "lambda" {
    name = "lambda"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "lambda" {
    name = "test_policy"
    role = "${aws_iam_role.lambda.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "ec2:DescribeInstances",
                "ec2:CreateNetworkInterface",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:DetachNetworkInterface",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:ResetNetworkInterfaceAttribute",
                "autoscaling:*",
                "sqs:*",
                "dynamodb:*"
            ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}



resource "aws_lambda_function" "find_hash" {
    filename = "../lambdas/find_hash/find_hash.zip"
    source_code_hash = "${base64sha256(file("../lambdas/find_hash/find_hash.zip"))}"
    function_name = "rcha_find_hash"
    role = "${aws_iam_role.lambda.arn}"
    handler = "main.main"
    runtime = "python2.7"
    timeout = 30

   
}


resource "aws_lambda_permission" "find_hash_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.find_hash.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.rcha.id}/*/${aws_api_gateway_method.find_post.http_method}/*"
}




resource "aws_lambda_function" "hash_status" {
    filename = "../lambdas/hash_status/hash_status.zip"
    source_code_hash = "${base64sha256(file("../lambdas/hash_status/hash_status.zip"))}"
    function_name = "rcha_hash_status"
    role = "${aws_iam_role.lambda.arn}"
    handler = "main.main"
    runtime = "python2.7"
    timeout = 30
}


resource "aws_lambda_permission" "hash_status_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hash_status.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.rcha.id}/*/${aws_api_gateway_method.find_get.http_method}/*"
}




resource "aws_lambda_function" "scale_get" {
    filename = "../lambdas/get_scale/get_scale.zip"
    source_code_hash = "${base64sha256(file("../lambdas/get_scale/get_scale.zip"))}"
    function_name = "rcha_scale_get"
    role = "${aws_iam_role.lambda.arn}"
    handler = "main.main"
    runtime = "python2.7"
    timeout = 30
}


resource "aws_lambda_permission" "scale_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.scale_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.rcha.id}/*/${aws_api_gateway_method.scale_get.http_method}/*"
}




resource "aws_lambda_function" "scale_set" {
    filename = "../lambdas/scale_set/scale_set.zip"
    source_code_hash = "${base64sha256(file("../lambdas/scale_set/scale_set.zip"))}"
    function_name = "rcha_scale_set"
    role = "${aws_iam_role.lambda.arn}"
    handler = "main.main"
    runtime = "python2.7"
    timeout = 30
}


resource "aws_lambda_permission" "scale_set" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.scale_set.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.rcha.id}/*/${aws_api_gateway_method.scale_set.http_method}/*"
}