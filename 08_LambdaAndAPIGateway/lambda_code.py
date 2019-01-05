import os

def lambda_handler(event, context):
    body = "{} from Lambda!".format(os.environ['os_variable'])

    return {
      "statusCode": 200,
      "headers": {"Content-Type": "application/json"},
        "body": body
    }
