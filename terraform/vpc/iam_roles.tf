data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


# Jumphost IAM instance role definition

resource "aws_iam_instance_profile" "jumphost_profile" {
  name = "${aws_iam_role.jumphost_role.name}"
  role = "${aws_iam_role.jumphost_role.name}"
}

resource "aws_iam_role" "jumphost_role" {
  name               = "jumphost_role_demo"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}


resource "aws_iam_role_policy_attachment" "jumphost_policy_codecommit_readonly" {
  role       = "${aws_iam_role.jumphost_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "aws_iam_role_policy_attachment" "jumphost_policy_ec2_readonly" {
  role       = "${aws_iam_role.jumphost_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


# Jenkins IAM instance role definition

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "${aws_iam_role.jenkins_role.name}"
  role = "${aws_iam_role.jenkins_role.name}"
}

resource "aws_iam_role" "jenkins_role" {
  name               = "jenkins_role_demo"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}


resource "aws_iam_role_policy_attachment" "jenkins_policy_codecommit_readonly" {
  role       = "${aws_iam_role.jenkins_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "aws_iam_role_policy_attachment" "jenkins_policy_ec2_readonly" {
  role       = "${aws_iam_role.jenkins_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


# Kubernetes master node IAM instance role definition
resource "aws_iam_instance_profile" "k8smaster_profile" {
  name = "${aws_iam_role.k8smaster_role.name}"
  role = "${aws_iam_role.k8smaster_role.name}"
}

resource "aws_iam_role" "k8smaster_role" {
  name               = "k8smaster_role_demo"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}


resource "aws_iam_role_policy_attachment" "k8smaster_policy_codecommit_readonly" {
  role       = "${aws_iam_role.k8smaster_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "aws_iam_role_policy_attachment" "k8smaster_policy_ec2_readonly" {
  role       = "${aws_iam_role.k8smaster_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


# Kubernetes node IAM instance role definition
resource "aws_iam_instance_profile" "k8snode_profile" {
  name = "${aws_iam_role.k8snode_role.name}"
  role = "${aws_iam_role.k8snode_role.name}"
}

resource "aws_iam_role" "k8snode_role" {
  name               = "k8snode_role_demo"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}


resource "aws_iam_role_policy_attachment" "k8node_policy_codecommit_readonly" {
  role       = "${aws_iam_role.k8snode_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "aws_iam_role_policy_attachment" "k8node_policy_ec2_readonly" {
  role       = "${aws_iam_role.k8snode_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
