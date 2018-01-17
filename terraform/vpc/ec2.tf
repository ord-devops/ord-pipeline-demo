
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
  public_key = "${file(var.pubkey_path)}"
}

# Jumphost server autoscaling group
resource "aws_launch_configuration" "jumphost" {
  name_prefix = "jumphost_"
  image_id           = "${data.aws_ami.centos.id}"
  instance_type = "t2.nano"
  security_groups = ["${aws_security_group.jumphost.id}"]
  associate_public_ip_address = true
  key_name = "${aws_key_pair.centos.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.jumphost_profile.name}"
  user_data            = "${data.template_file.user_data.rendered}"
  
  root_block_device {
    delete_on_termination = true
  }
  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }

  
}

resource "aws_autoscaling_group" "jumphost" {
  name                 = "jumphost"
  max_size             = "1"
  min_size             = "0"
  desired_capacity     = "1"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.jumphost.id}"
  vpc_zone_identifier  = ["${module.vpc.public_1a_id}","${module.vpc.public_1b_id}","${module.vpc.public_1c_id}"]

  tag {
    key                 = "Name"
    value               = "jumphost"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "role"
    value               = "jumphost"
    propagate_at_launch = "true"
  }

}


# Jenkins server autoscaling group
resource "aws_launch_configuration" "jenkins" {
  name_prefix = "jenkins_"
  image_id           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.k8s.id}"]
  key_name = "${aws_key_pair.centos.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.jenkins_profile.name}"
  user_data            = "${data.template_file.user_data.rendered}"
  
  root_block_device {
    delete_on_termination = true
  }
  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }

  
}

resource "aws_autoscaling_group" "jenkins" {
  name                 = "jenkins"
  max_size             = "1"
  min_size             = "0"
  desired_capacity     = "1"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.jenkins.id}"
  vpc_zone_identifier  = ["${module.vpc.private_1a_id}","${module.vpc.private_1b_id}","${module.vpc.private_1c_id}"]

  tag {
    key                 = "Name"
    value               = "jenkins"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "role"
    value               = "jenkins"
    propagate_at_launch = "true"
  }

}


# Kubernetes master autoscaling group
resource "aws_launch_configuration" "k8smaster" {
  name_prefix = "k8smaster_"
  image_id           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.k8s.id}"]
  key_name = "${aws_key_pair.centos.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.k8smaster_profile.name}"
  user_data            = "${data.template_file.user_data.rendered}"
  
  root_block_device {
    delete_on_termination = true
  }
  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "k8smaster" {
  name                 = "k8smaster"
  max_size             = "1"
  min_size             = "0"
  desired_capacity     = "1"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.k8smaster.id}"
  vpc_zone_identifier  = ["${module.vpc.private_1a_id}","${module.vpc.private_1b_id}","${module.vpc.private_1c_id}"]

  tag {
    key                 = "Name"
    value               = "k8smaster"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "role"
    value               = "k8smaster"
    propagate_at_launch = "true"
  }

}



# Kubernetes node autoscaling group launch configuration
resource "aws_launch_configuration" "k8snode" {
  name_prefix          = "k8snode_"
  image_id             = "${data.aws_ami.centos.id}"
  instance_type        = "t2.micro"
  security_groups      = ["${aws_security_group.k8s.id}"]
  user_data            = "${data.template_file.user_data.rendered}"
  key_name             = "${aws_key_pair.centos.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.k8snode_profile.name}"

  root_block_device {
    delete_on_termination = true
  }

  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k8snodes" {
  name                 = "k8snodes"
  max_size             = "3"
  min_size             = "0"
  desired_capacity     = "3"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.k8snode.id}"
  vpc_zone_identifier  = ["${module.vpc.private_1a_id}","${module.vpc.private_1b_id}","${module.vpc.private_1c_id}"]

  tag {
    key                 = "Name"
    value               = "${aws_launch_configuration.k8snode.name}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "role"
    value               = "k8snode"
    propagate_at_launch = "true"
  }

}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"
  vars {
    custom_userdata = "${var.custom_userdata}"
    ansible_version = "${var.ansible_version}"
    ansible_pull_repo = "${var.ansible_pull_repo}"
      }
}