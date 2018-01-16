terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }
}

custom_userdata = ""
ansible_version = "2.4.2.0"
ansible_pull_repo = "https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/ord-demo-ansible-pull"
ec2_key_pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5qZOVMaOwZZDT07PxksfV91mWjRdh13P/D7tzEboKF6or8A+29ayTyBHDIqBdOe8aR3Z/77qIY5g5hIkr3EqEbw8iWOc+JI+7qlJoZq4rdT6R6aPOOFTQHii7K8ovBosv1Pw5VgPJV+lr3WE0U4rII0A2BKLCrGigUo91FPEy6Rh6sUGtuyTzCPsG4d9a2zGaWYXWzmbIX7oPpkdFTi+qHs9wR5gNTvrFPgEIvnTL2Uj+AFE+svvs1TVQbUlKUBr/fZ+MJp1/kzmcQMtsscSJs+jkajeO9UmKB63rJCskNQWNrHahXySI8bSFT22QYSbeXcsKvbTxLr29pU1oBmRd nralbers@altair"