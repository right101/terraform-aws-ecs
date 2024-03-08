resource "aws_vpc" "ecs_vpc" {
  cidr_block = "var.vpc_cidr_block"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ecs_vpc"
  }
}

resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs_igw"
  }
}

resource "aws_subnet" "ecs_public_subnet" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true 

  tags                    = {
    Name = "ecs_public_subnet"
  }
}

resource "aws_route_table" "ecs_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.ecs_igw.id
  }

  tags = {
    Name = "ecs_route_table"
  }
}

resource "aws_route_table_association" "ecs_route_table_assoc" {
  subnet_id      = aws_subnet.ecs_public_subnet.id
  route_table_id = aws_route_table.ecs_route_table.id
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs_sg"
  }
}
resource "aws_security_group_rule" "ingress" {
  count = length(var.ports) 
  type              = "ingress"
  to_port           = element( var.ports, count.index) 
  protocol          = var.protocol
  from_port         = element( var.ports, count.index) 
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = [var.cidr_block]
}
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = [var.cidr_block]
}
