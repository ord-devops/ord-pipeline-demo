resource "aws_vpc" "current_vpc" {
  enable_dns_support               = "true"
  enable_dns_hostnames             = "true"
  assign_generated_ipv6_cidr_block = "true"
  cidr_block                       = "${var.cidr_block}"

  tags {
    Name        = "${var.vpc_name}"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

# Declare the data source
data "aws_availability_zones" "available" {}

resource "aws_subnet" "private-1a" {
  vpc_id                          = "${aws_vpc.current_vpc.id}"
  cidr_block                      = "${cidrsubnet(aws_vpc.current_vpc.cidr_block,2,0)}"
  availability_zone               = "${data.aws_availability_zones.available.names[0]}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.current_vpc.ipv6_cidr_block, 8, 0)}"
  assign_ipv6_address_on_creation = true

  tags {
    Name        = "${var.vpc_name} private-1a"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id                          = "${aws_vpc.current_vpc.id}"
  cidr_block                      = "${cidrsubnet(aws_vpc.current_vpc.cidr_block,2,1)}"
  availability_zone               = "${data.aws_availability_zones.available.names[1]}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.current_vpc.ipv6_cidr_block, 8, 1)}"
  assign_ipv6_address_on_creation = true

  tags {
    Name        = "${var.vpc_name} private-1b"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id                          = "${aws_vpc.current_vpc.id}"
  cidr_block                      = "${cidrsubnet(aws_vpc.current_vpc.cidr_block,2,2)}"
  availability_zone               = "${data.aws_availability_zones.available.names[2]}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.current_vpc.ipv6_cidr_block, 8, 2)}"
  assign_ipv6_address_on_creation = true

  tags {
    Name        = "${var.vpc_name} private-1c"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id                          = "${aws_vpc.current_vpc.id}"
  cidr_block                      = "${cidrsubnet(cidrsubnet(aws_vpc.current_vpc.cidr_block,2,3),2,0)}"
  availability_zone               = "${data.aws_availability_zones.available.names[0]}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.current_vpc.ipv6_cidr_block, 8, 3)}"
  assign_ipv6_address_on_creation = true

  tags {
    Name        = "${var.vpc_name} public-1a"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id                          = "${aws_vpc.current_vpc.id}"
  cidr_block                      = "${cidrsubnet(cidrsubnet(aws_vpc.current_vpc.cidr_block,2,3),2,1)}"
  availability_zone               = "${data.aws_availability_zones.available.names[1]}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.current_vpc.ipv6_cidr_block, 8, 4)}"
  assign_ipv6_address_on_creation = true

  tags {
    Name        = "${var.vpc_name} public-1b"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_subnet" "public-1c" {
  vpc_id                          = "${aws_vpc.current_vpc.id}"
  cidr_block                      = "${cidrsubnet(cidrsubnet(aws_vpc.current_vpc.cidr_block,2,3),2,2)}"
  availability_zone               = "${data.aws_availability_zones.available.names[2]}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.current_vpc.ipv6_cidr_block, 8, 5)}"
  assign_ipv6_address_on_creation = true

  tags {
    Name        = "${var.vpc_name} public-1c"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.current_vpc.id}"

  tags {
    Name        = "${var.vpc_name} internet gateway"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_egress_only_internet_gateway" "internet_ro_gateway" {
  vpc_id = "${aws_vpc.current_vpc.id}"
}

resource "aws_eip" "nat_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.nat_ip.id}"
  subnet_id     = "${aws_subnet.public-1a.id}"
  depends_on    = ["aws_internet_gateway.internet_gateway"]

  tags {
    Name        = "${var.vpc_name} NAT gateway"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_default_route_table" "route_default" {
  default_route_table_id = "${aws_vpc.current_vpc.default_route_table_id}"

  tags {
    Name = "${var.vpc_name} routetable default unused"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_route_table" "route_public" {
  vpc_id = "${aws_vpc.current_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.internet_ro_gateway.id}"
  }

  tags {
    Name        = "${var.vpc_name} routetable public"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_route_table" "route_private" {
  vpc_id = "${aws_vpc.current_vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.internet_ro_gateway.id}"
  }

  tags {
    Name        = "${var.vpc_name} routetable private"
    environment = "${var.vpc_env}"
    role        = "networking"
    KubernetesCluster = "${var.k8s_cluster}"
  }
}

resource "aws_route_table_association" "route-ass-public-1a" {
  subnet_id      = "${aws_subnet.public-1a.id}"
  route_table_id = "${aws_route_table.route_public.id}"
}

resource "aws_route_table_association" "route-ass-public-1b" {
  subnet_id      = "${aws_subnet.public-1b.id}"
  route_table_id = "${aws_route_table.route_public.id}"
}


resource "aws_route_table_association" "route-ass-public-1c" {
  subnet_id      = "${aws_subnet.public-1c.id}"
  route_table_id = "${aws_route_table.route_public.id}"
}

resource "aws_route_table_association" "route-ass-private-1a" {
  subnet_id      = "${aws_subnet.private-1a.id}"
  route_table_id = "${aws_route_table.route_private.id}"
}

resource "aws_route_table_association" "route-ass-private-1b" {
  subnet_id      = "${aws_subnet.private-1b.id}"
  route_table_id = "${aws_route_table.route_private.id}"
}

resource "aws_route_table_association" "route-ass-private-1c" {
  subnet_id      = "${aws_subnet.private-1c.id}"
  route_table_id = "${aws_route_table.route_private.id}"
}

