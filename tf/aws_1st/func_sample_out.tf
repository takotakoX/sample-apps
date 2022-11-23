# ECR
resource "aws_ecr_repository" "sample_out" {
  name                 = "sample-out"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "image_push_sample_out" {
  provisioner "local-exec" {
    command = <<-EOF
      docker build ../../lambda/src/sample_out_func/ -t ${aws_ecr_repository.sample_out.repository_url}:terraform; \
      docker login -u AWS -p ${data.aws_ecr_authorization_token.token.password} ${data.aws_ecr_authorization_token.token.proxy_endpoint}; \
      docker push ${aws_ecr_repository.sample_out.repository_url}:terraform
    EOF
  }
}

# Lambda Function
resource "aws_lambda_function" "sample_out" {
  depends_on = [
    null_resource.image_push_sample_out,
  ]

  function_name = "sample-out"
  role          = aws_iam_role.lambda_basic.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.sample_out.repository_url}:terraform"
  memory_size   = 128
  ephemeral_storage { size = 512 }
  timeout = 30

  lifecycle {
    ignore_changes = [image_uri]
  }
}

# CloudWatch Logs
## ref https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/monitoring-cloudwatchlogs.html
resource "aws_cloudwatch_log_group" "sample_out" {
  name              = "/aws/lambda/${aws_lambda_function.sample_out.function_name}"
  retention_in_days = 30
}