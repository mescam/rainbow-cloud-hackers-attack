resource "aws_api_gateway_rest_api" "rcha" {
  name = "RCHA"
  description = "Rainbow Cloud Hackers Attack API"
}

resource "aws_api_gateway_resource" "find" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  parent_id = "${aws_api_gateway_rest_api.rcha.root_resource_id}"
  path_part = "find"
}

resource "aws_api_gateway_resource" "find_get" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  parent_id = "${aws_api_gateway_resource.find.id}"
  path_part = "{tid}"
}

resource "aws_api_gateway_resource" "generate" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  parent_id = "${aws_api_gateway_rest_api.rcha.root_resource_id}"
  path_part = "generate"
}

resource "aws_api_gateway_resource" "scale" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  parent_id = "${aws_api_gateway_rest_api.rcha.root_resource_id}"
  path_part = "scale"
}

resource "aws_api_gateway_method" "find_get" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.find_get.id}"
  http_method = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_method" "find_post" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.find.id}"
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "scale_get" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.scale.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "scale_set" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.scale.id}"
  http_method = "POST"
  authorization = "NONE"
}

/*resource "aws_api_gateway_method" "generate_post" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.generate.id}"
  http_method = "POST"
  authorization = "NONE"
}





*/

resource "aws_api_gateway_integration" "find_get" {
  rest_api_id             = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id             = "${aws_api_gateway_resource.find_get.id}"
  http_method             = "${aws_api_gateway_method.find_get.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.hash_status.arn}/invocations"

request_templates {
    "application/json" = <<EOF
{"tid" : "$input.params('tid')"}
EOF
  }
}


resource "aws_api_gateway_method_response" "find_get_200" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.find_get.id}"
  http_method = "${aws_api_gateway_method.find_get.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "find_get_200" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.find_get.id}"
  http_method = "${aws_api_gateway_method.find_get.http_method}"
  status_code = "${aws_api_gateway_method_response.find_get_200.status_code}"


}




resource "aws_api_gateway_integration" "find_post" {
  rest_api_id             = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id             = "${aws_api_gateway_resource.find.id}"
  http_method             = "${aws_api_gateway_method.find_post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.find_hash.arn}/invocations"
}


resource "aws_api_gateway_method_response" "find_post_200" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.find.id}"
  http_method = "${aws_api_gateway_method.find_post.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "find_post_200" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.find.id}"
  http_method = "${aws_api_gateway_method.find_post.http_method}"
  status_code = "${aws_api_gateway_method_response.find_post_200.status_code}"
}




resource "aws_api_gateway_integration" "scale_get" {
  rest_api_id             = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id             = "${aws_api_gateway_resource.scale.id}"
  http_method             = "${aws_api_gateway_method.scale_get.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.scale_get.arn}/invocations"
}


resource "aws_api_gateway_method_response" "scale_get_200" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.scale.id}"
  http_method = "${aws_api_gateway_method.scale_get.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "scale_get_200" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.scale.id}"
  http_method = "${aws_api_gateway_method.scale_get.http_method}"
  status_code = "${aws_api_gateway_method_response.scale_get_200.status_code}"
}




resource "aws_api_gateway_integration" "scale_set" {
  rest_api_id             = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id             = "${aws_api_gateway_resource.scale.id}"
  http_method             = "${aws_api_gateway_method.scale_set.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.scale_set.arn}/invocations"
}


resource "aws_api_gateway_method_response" "scale_set_200" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.scale.id}"
  http_method = "${aws_api_gateway_method.scale_set.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "scale_set_200" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  resource_id = "${aws_api_gateway_resource.scale.id}"
  http_method = "${aws_api_gateway_method.scale_set.http_method}"
  status_code = "${aws_api_gateway_method_response.scale_set_200.status_code}"
}







resource "aws_api_gateway_deployment" "rcha" {
  rest_api_id = "${aws_api_gateway_rest_api.rcha.id}"
  stage_name = "prod"
}

