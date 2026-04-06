output "repository_arn" {
  value = aws_ecr_repository.this.arn
}

output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "repository_name" {
  value = aws_ecr_repository.this.name
}

# Full URI including digest of the most recently pushed image.
# Changes automatically on every terraform apply after a new image is pushed.
output "latest_image_uri" {
  value = "${aws_ecr_repository.this.repository_url}@${data.aws_ecr_image.latest.image_digest}"
}
