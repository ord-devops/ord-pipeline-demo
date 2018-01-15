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
