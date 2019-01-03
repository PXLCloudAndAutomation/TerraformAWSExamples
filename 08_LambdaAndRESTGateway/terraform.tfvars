region = "us-east-1"

lambda_function_name = "example_lambda"

code_archive = {
  type        = "zip"
  source_file = "./lambda_code.py"
  output_path = "./lambda_code.zip"
  handler     = "lambda_code.lambda_handler"
  runtime     = "python3.6"
  execute_argument = "Hi"
}

