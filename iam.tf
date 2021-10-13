resource "aws_iam_instance_profile" "vault-instance-profile" {
  name = "army_vault_instance_profile"
  role = aws_iam_role.vault-instance-role.name
}

data "aws_iam_policy_document" "vault-instance-policy-doc" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      # these permissions are necessary for the ec2 instance to associate itself with
      # an elastic IP address on startup
      "ec2:DescribeAddresses",
      "ec2:AllocateAddress",
      "ec2:DescribeInstances",
      "ec2:AssociateAddress"
    ]

    effect = "Allow"

    resources = ["*"]
  }
}

resource "aws_iam_policy" "vault-instance-policy" {
  name   = "vault-instance-policy"
  policy = data.aws_iam_policy_document.vault-instance-policy-doc.json
}

resource "aws_iam_role" "vault-instance-role" {
  name = "vault-instance-role"
  path = "/"

  tags = merge(local.tags, { Name = "vault-instance-role" })

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Principal": {"Service": "ec2.amazonaws.com"},
        "Action": "sts:AssumeRole"
    }
]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vault-instance-policy-attachment" {
  role       = aws_iam_role.vault-instance-role.name
  policy_arn = aws_iam_policy.vault-instance-policy.arn
}
