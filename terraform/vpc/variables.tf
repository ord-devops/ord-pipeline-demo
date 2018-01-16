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