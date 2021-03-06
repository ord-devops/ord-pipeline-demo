terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "ord-ff-tf-state"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "eu-central-1"
      encrypt        = true
      dynamodb_table = "ord-ff-terraform-state-lock-dev"
      profile        = "demo"
    }
  }
}