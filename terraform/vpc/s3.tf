resource "aws_s3_bucket" "keystore" {
  bucket = "${var.keystore_bucket}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags {
    Name        = "${var.keystore_bucket}"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_object" "pubkey" {
  bucket = "${aws_s3_bucket.keystore.id}"
  key    = "${var.pubkey}"
  source = "${var.pubkey_path}"
  etag   = "${md5(file(var.pubkey_path))}"
}

resource "aws_s3_bucket_object" "privkey" {
  bucket = "${aws_s3_bucket.keystore.id}"
  key    = "${var.privkey}"
  source = "${var.privkey_path}"
  etag   = "${md5(file(var.privkey_path))}"
}

resource "aws_s3_bucket_object" "jenkins_github_token" {
  bucket = "${aws_s3_bucket.keystore.id}"
  key    = "jenkins_github_token"
  content = "${var.jenkins_github_token}"
  etag   = "${md5(${var.jenkins_github_token})}"
}