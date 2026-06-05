import logging
import urllib.parse

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    for record in event.get("Records", []):
        key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])
        logger.info("Image received: %s", key)

    return {"statusCode": 200}
