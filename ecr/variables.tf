variable "region" {
  description = "AWS Region to be used (it effects all resources)"
  type        = string
}

variable "name" {
  description = "Name of the respository"
  type        = string
}

variable "image_tag_mutability" {
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  type        = bool
  default     = false
}

variable "iam_policy" {
  description = "(Required) The policy document. This is a JSON formatted string."
  type        = string
  default = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "new statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::root"
        ]
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchDeleteImage",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DeleteLifecyclePolicy",
        "ecr:DeleteRepository",
        "ecr:DeleteRepositoryPolicy",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:PutLifecyclePolicy",
        "ecr:SetRepositoryPolicy",
        "ecr:StartLifecyclePolicyPreview",
        "ecr:UploadLayerPart"
      ]
    }
  ]
}
EOF
}

variable "lifecycle_policy" {
  description = ""
  type        = string
  default = <<EOF
{
    "rules": [
        {
            "rulePriority": 10,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 20,
            "description": "limit to 300 ci tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["ci-"],
                "countType": "imageCountMoreThan",
                "countNumber": 300
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

variable "tfversion" {
  description = "Current terraform version"
  type        = string
  default     = null
}