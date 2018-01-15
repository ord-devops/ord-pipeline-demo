module "vpc" {
  source = "../modules/vpc"

  vpc_name   = "kub8_vpc"
  vpc_env    = "demo"
  cidr_block = "10.127.0.0/21"
}



# Security group def, probably want this to be moved to a sep file

resource "aws_security_group" "jumphost" {
  name        = "jumphost"
  description = "jumphost allow ssh traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "jenkins allow ssh and jenkins traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    security_groups = ["${aws_security_group.jumphost.id}"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "6"
    security_groups = ["${aws_security_group.alb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "kub8" {
  name        = "kub8"
  description = "allow internal kubernetes traffic"
  vpc_id      = "${module.vpc.vpc_id}"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    security_groups = ["${aws_security_group.jumphost.id}"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = ["${aws_security_group.jenkins.id}"]
    self = true
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name        = "load ballancer"
  description = "load ballancer allow http and https traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
