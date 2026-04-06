resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = var.tags
}

# Resolves the most recently pushed image at apply time.
# Requires at least one image to have been pushed to the repository.
# On bootstrap (first apply before any image exists), target the runtime
# module separately after the first image is pushed by app CI.
data "aws_ecr_image" "latest" {
  repository_name = aws_ecr_repository.this.name
  most_recent     = true
}
