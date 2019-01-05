aws lambda invoke --region=us-east-1 --function-name=example_lambda output.txt
{
    "StatusCode": 200,
        "ExecutedVersion": "$LATEST"
        }

cat output.txt
Hi from Lambda!

Firefox:
SyntaxError: JSON.parse: unexpected character at line 1 column 1 of the JSON data
