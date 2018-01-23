variable "cidr_block" {
  description = "The VPC CIDR block"
}

variable "vpc_name" {
  description = "The VPC name"
}

variable "vpc_env" {
  description = "The VPC environment"
}

variable "k8s_cluster" {
  description = "Kubernetes cluster name for AWS tagging"
  default = "democluster"
}