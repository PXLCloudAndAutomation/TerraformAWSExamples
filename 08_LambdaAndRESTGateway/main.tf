# Specify the provider and access details
provider "aws" {
  region = "${var.region}"
  version = "~> 1.54"
}

provider "archive" {
  version = "~> 1.1"
}

data "archive_file" "zip" {
  type        = "${var.code_archive["type"]}"
  source_file = "${var.code_archive["source_file"]}"
  output_path = "${var.code_archive["output_path"]}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.lambda_function_name}"

  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"

  role    = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "${var.code_archive["handler"]}"
  runtime = "${var.code_archive["runtime"]}"

  environment {
    variables = {
      os_variable = "${var.code_archive["execute_argument"]}"
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}

output "lambda" {
    value = "${aws_lambda_function.lambda.qualified_arn}"
}
