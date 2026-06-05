resource "aws_s3_bucket" "assets" {
  bucket = local.assets_bucket_name

  tags = {
    Name = local.assets_bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "archive_file" "asset_processor" {
  type        = "zip"
  source_file = "${path.module}/../lambda/asset_processor.py"
  output_path = "${path.module}/.terraform/asset_processor.zip"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "asset_processor" {
  name               = "bedrock-asset-processor-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Name = "bedrock-asset-processor-role"
  }
}

resource "aws_iam_role_policy_attachment" "asset_processor_logs" {
  role       = aws_iam_role.asset_processor.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "asset_processor" {
  function_name = "bedrock-asset-processor"
  role          = aws_iam_role.asset_processor.arn
  handler       = "asset_processor.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.asset_processor.output_path
  source_code_hash = data.archive_file.asset_processor.output_base64sha256

  tags = {
    Name = "bedrock-asset-processor"
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

resource "aws_s3_bucket_notification" "asset_upload" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
