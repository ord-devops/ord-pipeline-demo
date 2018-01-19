resource "aws_ecr_repository" "demo_app" {
  name = "demo_app"
}


resource "aws_s3_bucket_object" "ecr_repo_url" {
  bucket = "${aws_s3_bucket.keystore.id}"
  key    = "ecr_repo_url"
  content = "${aws_ecr_repository.demo_app.repository_url}"
  etag   = "${md5(aws_ecr_repository.demo_app.repository_url)}"
}