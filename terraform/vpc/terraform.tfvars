terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }
}

custom_userdata = ""
ansible_version = "2.4.2.0"
ansible_pull_repo = "https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/ord-demo-ansible-pull"
pubkey_path = "~/.ssh/centos_rsa.pub"
privkey_path = "~/.ssh/centos_rsa"