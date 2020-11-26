resource "aws_iam_role" "iam_role" {
  name = "${local.stack_name}-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "lambda.amazonaws.com"
            ]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
}

resource "aws_iam_role_policy" "permission_policy" {
  name = local.stack_name
  role = aws_iam_role.iam_role.id

  policy = jsonencode(
  {
    "Statement" : [{
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "*"
        ],
        "Effect" : "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}