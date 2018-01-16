resource "aws_s3_bucket" "keystore" {
  bucket = "ord-demo-keystore"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags {
    Name        = "ord-demo-keystore"
    Environment = "demo"
  }
}

resource "aws_s3_bucket_object" "pubkey" {
  bucket = "${aws_s3_bucket.keystore.id}"
  key    = "centos_rsa.pub"
  source = "${var.pubkey_path}"
  etag   = "${md5(file(var.pubkey_path))}"
}

resource "aws_s3_bucket_object" "privkey" {
  bucket = "${aws_s3_bucket.keystore.id}"
  key    = "centos_rsa"
  source = "${var.privkey_path}"
  etag   = "${md5(file(var.privkey_path))}"
}