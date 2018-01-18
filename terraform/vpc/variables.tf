variable "vpc_cidr" {
  description = "CIDR block to assign to new VPC"
}

variable "custom_userdata" {
  type = "string"
  description = "userdata for inserting in cloud init script"
  default = ""
}

variable "ansible_version" {
  description = "Ansible version to install"
}

variable "ansible_pull_repo" {
  description = "repository to pull ansible playbook from"
}

variable "pubkey_path" {
  description = "path to public key"
}

variable "pubkey" {
  description = "public keyfile name"
}

variable "privkey_path" {
  description = "path to private key"
}

variable "privkey" {
  description = "private keyfile name"
}

variable "keystore_bucket" {
  type = "string"
  description = "bucket name for the keystore"
}

variable "environment" {
  description = "environment to tag"
  default = "demo"
}

variable "jenkins_github_token" {
  type = "string"
  description = "token for jenkins access to github"
}