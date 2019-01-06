# Example `08_LambdaAndAPIGateway`
This example creates an Amazon Lambda function with an Amazon API Gateway.

> "AWS Lambda lets you run code without provisioning or managing servers. You pay only for the compute time you consume - there is no charge when your code is not running. " - [source](https://aws.amazon.com/lambda/)

# Testing the infrastructure
The Terraform script will return the base_url.

An example:

```bash
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

base_url = https://v9chpl0zye.execute-api.us-east-1.amazonaws.com/execute
lambda = arn:aws:lambda:us-east-1:936275002182:function:example_lambda:$LATEST
```

Use this to test with `wget`, `aws` or a browser.

## Test with `wget`:

```bash
$ wget  https://v9chpl0zye.execute-api.us-east-1.amazonaws.com/execute
--2019-01-06 12:43:52--  https://v9chpl0zye.execute-api.us-east-1.amazonaws.com/execute
Resolving v9chpl0zye.execute-api.us-east-1.amazonaws.com (v9chpl0zye.execute-api.us-east-1.amazonaws.com)... 54.192.13.207, 54.192.13.182, 54.192.13.229, ...
Connecting to v9chpl0zye.execute-api.us-east-1.amazonaws.com (v9chpl0zye.execute-api.us-east-1.amazonaws.com)|54.192.13.207|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 15 [application/json]
Saving to: 'execute'

execute                                                     100%[=========================================================================================================================================>]      15  --.-KB/s    in 0s

2019-01-06 12:43:53 (1.43 MB/s) - 'execute' saved [15/15]

$ cat execute
Hi from Lambda!
```

## Test with the `aws` CLI command:
```bash
$ aws lambda invoke --region=us-east-1 --function-name=example_lambda outfile
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
$ cat outfile
{"statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "Hi from Lambda!"}
```

## Test with a browser:
Surf to the URL and see the result.

### Known Firefox issue:
Firefox will return an error:

```bash
SyntaxError: JSON.parse: unexpected character at line 1 column 1 of the JSON data
```
It's known.