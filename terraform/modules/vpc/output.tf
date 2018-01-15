output "vpc_id" {
  value = "${aws_vpc.current_vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.current_vpc.cidr_block}"
}

output "nat_ip" {
  value = "${aws_nat_gateway.nat_gateway.public_ip}"
}

output "public_1a_id" {
  value = "${aws_subnet.public-1a.id}"
}

output "public_1b_id" {
  value = "${aws_subnet.public-1b.id}"
}

output "public_1c_id" {
  value = "${aws_subnet.public-1c.id}"
}

output "public_1a_cidr" {
  value = "${aws_subnet.public-1a.cidr_block}"
}

output "public_1b_cidr" {
  value = "${aws_subnet.public-1b.cidr_block}"
}

output "public_1c_cidr" {
  value = "${aws_subnet.public-1c.cidr_block}"
}

output "private_1a_id" {
  value = "${aws_subnet.private-1a.id}"
}

output "private_1b_id" {
  value = "${aws_subnet.private-1b.id}"
}

output "private_1c_id" {
  value = "${aws_subnet.private-1c.id}"
}

output "private_1a_cidr" {
  value = "${aws_subnet.private-1a.cidr_block}"
}

output "private_1b_cidr" {
  value = "${aws_subnet.private-1b.cidr_block}"
}

output "private_1c_cidr" {
  value = "${aws_subnet.private-1c.cidr_block}"
}