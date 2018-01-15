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

# Jumphost instance. Needs public IP for external access, rest of VPC is all private instances
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


# Jenkins server instance. Private instance. Placed in private 1a subnet
resource "aws_instance" "jenkins" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  subnet_id = "${module.vpc.private_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins.id}"]
  key_name = "${aws_key_pair.centos.key_name}"

  tags {
    Name = "jenkins"
    environment = "demo"
    role = "build"
  }
}


# Kubernetes master instance. Placed in private 1c subnet
resource "aws_instance" "k8master" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  subnet_id = "${module.vpc.private_1b_id}"
  vpc_security_group_ids = ["${aws_security_group.kub8.id}"]
  key_name = "${aws_key_pair.centos.key_name}"

  tags {
    Name = "k8master"
    environment = "demo"
    role = "build"
  }
}


# Kubernetes node autoscaling group launch configuration
resource "aws_launch_configuration" "launch" {
  name_prefix          = "k8node_"
  image_id             = "${data.aws_ami.centos.id}"
  instance_type        = "t2.micro"
  security_groups      = ["${aws_security_group.kub8.id}"]
  user_data            = "${data.template_file.user_data.rendered}"
  key_name             = "${aws_key_pair.centos.key_name}"

  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "k8cluster"
  max_size             = "3"
  min_size             = "3"
  desired_capacity     = "3"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.launch.id}"
  vpc_zone_identifier  = ["${module.vpc.private_1a_id}","${module.vpc.private_1b_id}","${module.vpc.private_1c_id}"]

  tag {
    key                 = "Name"
    value               = "k8node"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "environment"
    value               = "demo"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "role"
    value               = "kubernetes"
    propagate_at_launch = "true"
  }

}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"
}


output "jumphost_pub_ip" {
  value = "${aws_instance.jumphost.public_ip}"
}

output "jenkins_ip" {
  value = "${aws_instance.jenkins.private_ip}"
}

output "k8master_ip" {
  value = "${aws_instance.k8master.private_ip}"
}