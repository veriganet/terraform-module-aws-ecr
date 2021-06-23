# ########
# Provider
# ########

provider "aws" {
  region = var.region
}


# #########
# terraform
# #########
# rest of the backend part will be filled by terragrunt

terraform {
  backend "s3" {}
}


# ############
# ECR Resource
# ############

resource "aws_ecr_repository" "this" {
  name = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = var.iam_policy
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = var.lifecycle_policy
}
