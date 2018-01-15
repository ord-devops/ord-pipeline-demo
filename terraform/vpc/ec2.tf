# Jumphost


data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "centos" {
  key_name   = "centos-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5qZOVMaOwZZDT07PxksfV91mWjRdh13P/D7tzEboKF6or8A+29ayTyBHDIqBdOe8aR3Z/77qIY5g5hIkr3EqEbw8iWOc+JI+7qlJoZq4rdT6R6aPOOFTQHii7K8ovBosv1Pw5VgPJV+lr3WE0U4rII0A2BKLCrGigUo91FPEy6Rh6sUGtuyTzCPsG4d9a2zGaWYXWzmbIX7oPpkdFTi+qHs9wR5gNTvrFPgEIvnTL2Uj+AFE+svvs1TVQbUlKUBr/fZ+MJp1/kzmcQMtsscSJs+jkajeO9UmKB63rJCskNQWNrHahXySI8bSFT22QYSbeXcsKvbTxLr29pU1oBmRd nralbers@altair"
}

resource "aws_instance" "jumphost" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.nano"
  subnet_id = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.jumphost.id}"]
  associate_public_ip_address = true
  key_name = "${aws_key_pair.centos.key_name}"

  tags {
    Name = "jumphost"
    environment = "demo"
    role = "jumphost"
  }
}

output "jumphost_pub_ip" {
  value = "${aws_instance.jumphost.public_ip}"
}