module "vpc" {
  source = "../modules/vpc"

  vpc_name   = "k8s_vpc"
  vpc_env    = "${var.environment}"
  cidr_block = "${var.vpc_cidr}"
}



# Security group def, probably want this to be moved to a sep file

resource "aws_security_group" "jumphost" {
  name        = "jumphost"
  description = "jumphost allow ssh traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  tags {
    Name = "jumphost"
  }
}

resource "aws_security_group_rule" "jumphost_ssh" {
  type = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.jumphost.id}"
  description = "allow ssh access to jumphost"
}

resource "aws_security_group_rule" "egress_jumphost" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.jumphost.id}"
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "jenkins allow ssh and jenkins traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  tags {
    Name = "jenkins"
  }
}

resource "aws_security_group_rule" "jenkins_ssh_jumphost" {
  type = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = "${aws_security_group.jenkins.id}"
  source_security_group_id = "${aws_security_group.jumphost.id}"
  description = "allow ssh traffic from jumphost"
}

resource "aws_security_group_rule" "jenkins_ssh_self" {
  type = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = "${aws_security_group.jenkins.id}"
  self = true
  description = "allow ssh traffic from self"
}

resource "aws_security_group_rule" "jenkins_http" {
  type = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  security_group_id = "${aws_security_group.jenkins.id}"
  source_security_group_id = "${aws_security_group.alb.id}"
  description = "allow http traffic on 8080 from alb"
}

resource "aws_security_group_rule" "jenkins_slave_agent_port" {
  type = "ingress"
  from_port  = 50000
  to_port    = 50000
  protocol   = "tcp"
  security_group_id = "${aws_security_group.jenkins.id}"
  source_security_group_id = "${aws_security_group.k8s.id}"
  description = "allow slave agent traffic from kubernetes"
}

resource "aws_security_group_rule" "egress_jenkins" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.jenkins.id}"
}

resource "aws_security_group" "k8s" {
  name        = "kub8"
  description = "allow internal kubernetes traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  tags {
    Name = "k8s"
  }
}

resource "aws_security_group_rule" "k8s_ssh_jumphost" {
  type = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = "${aws_security_group.k8s.id}"
  source_security_group_id = "${aws_security_group.jumphost.id}"
  description = "Allow incoming ssh from jumphost"
}

resource "aws_security_group_rule" "k8s_ssh_jenkins" {
  type = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = "${aws_security_group.k8s.id}"
  source_security_group_id = "${aws_security_group.jenkins.id}"
  description = "Allow incoming ssh from jenkins"
}

resource "aws_security_group_rule" "k8s_jenkins" {
  type = "ingress"
  from_port   = 6443
  to_port     = 6443
  protocol    = "tcp"
  security_group_id = "${aws_security_group.k8s.id}"
  source_security_group_id = "${aws_security_group.jenkins.id}"
  description = "allow jenkins traffic to kubernetes api on 6443"
}

resource "aws_security_group_rule" "k8s_self" {
  type = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  security_group_id = "${aws_security_group.k8s.id}"
  self = true
  description = "allow all traffic from kubernetes"
}

resource "aws_security_group_rule" "egress_k8s" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.k8s.id}"  
}

resource "aws_security_group" "alb" {
  name        = "load balancer"
  description = "load balancer allow http and https traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  tags {
    Name = "alb"
  }
}

resource "aws_security_group_rule" "alb_http" {
  type = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.alb.id}"
  description = "allow http traffic"
}

resource "aws_security_group_rule" "alb_https" {
  type = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.alb.id}"
  description = "allow https traffic"
}

resource "aws_security_group_rule" "egress_alb" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.alb.id}"  
}



output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}


output "vpc_cidr" {
  value = "${module.vpc.vpc_cidr}"
}

output "nat_ip" {
  value = "${module.vpc.nat_ip}"
}

output "public_1a_id" {
  value = "${module.vpc.public_1a_id}"
}

output "public_1b_id" {
  value = "${module.vpc.public_1b_id}"
}

output "public_1c_id" {
  value = "${module.vpc.public_1c_id}"
}

output "public_1a_cidr" {
  value = "${module.vpc.public_1a_cidr}"
}

output "public_1b_cidr" {
  value = "${module.vpc.public_1b_cidr}"
}

output "public_1c_cidr" {
  value = "${module.vpc.public_1c_cidr}"
}

output "private_1a_id" {
  value = "${module.vpc.private_1a_id}"
}

output "private_1b_id" {
  value = "${module.vpc.private_1b_id}"
}

output "private_1c_id" {
  value = "${module.vpc.private_1c_id}"
}

output "private_1a_cidr" {
  value = "${module.vpc.private_1a_cidr}"
}

output "private_1b_cidr" {
  value = "${module.vpc.private_1b_cidr}"
}

output "private_1c_cidr" {
  value = "${module.vpc.private_1c_cidr}"
}
