variable "vpc_cidr_block" {
    type = string
    description = "this is for cidr_block"
    default  = "10.0.0.0/16"
}
variable "public_subnet_cidr_blocks" {
    type = list(string)
    description = "List of cidr blocks"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "cidr_block" {
    type = string
    description = "this is for route table cidr_block"
    default  = "0.0.0.0/0"
}
variable "ports" {
    type = list(string)
    description = "List of ports"
    default = ["22", "80", "3306", "443"]
}
variable "protocol" {
    type = string
    description = "this is for protocol"
    default  = "tcp"
}

