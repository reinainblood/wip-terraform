

# Existing VPC data source
data "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Fetch availability zones
data "aws_availability_zones" "available" {
  state = "available"
}



# Create subnets for TGW attachment
resource "aws_subnet" "tgw_subnets" {
  count             = 3
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = cidrsubnet(data.aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "TGW-Subnet-${count.index + 1}"
  }
}

# Create subnets for databases
resource "aws_subnet" "db_subnets" {
  count             = 3
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = cidrsubnet(data.aws_vpc.vpc.cidr_block, 8, count.index + 3)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "DB-Subnet-${count.index + 1}"
  }
}

# Create subnets for ECS cluster
resource "aws_subnet" "ecs_subnets" {
  count             = 3
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = cidrsubnet(data.aws_vpc.vpc.cidr_block, 8, count.index + 6)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ECS-Subnet-${count.index + 1}"
  }
}

# Create the Transit Gateway Attachment

resource "aws_ec2_transit_gateway_vpc_attachment" "new_tgw_attachment" {
  subnet_ids         = aws_subnet.tgw_subnets[*].id
  transit_gateway_id = var.tgw_id
  vpc_id             = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.env}TGW-Attachment-from-${var.parent}"
  }
}

# Create a route table for private subnets (DB and ECS)
resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }

  tags = {
    Name = "Private-RouteTable"
  }
}

# Associate the route table with DB subnets
resource "aws_route_table_association" "db_rt_assoc" {
  count          = length(aws_subnet.db_subnets)
  subnet_id      = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Associate the route table with ECS subnets
resource "aws_route_table_association" "ecs_rt_assoc" {
  count          = length(aws_subnet.ecs_subnets)
  subnet_id      = aws_subnet.ecs_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

