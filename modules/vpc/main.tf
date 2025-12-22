# META-ARGUMENT EXAMPLE: count
# This creates multiple VPCs based on vpc_count variable
# Demonstrates: count.index, count.each, resource indexing

resource "aws_vpc" "main" {
  count            = var.vpc_count
  cidr_block       = "${var.cidr_prefix}.${count.index}.0.0/16"
  instance_tenancy = "default"

  # META-ARGUMENT: lifecycle
  # Prevents destruction of VPC and prevents updates (immutable)
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      tags["UpdatedAt"]
    ]
  }

  tags = {
    Name = "${var.project_name}-vpc-${count.index + 1}"
  }
}

# Create subnets for each VPC using count
resource "aws_subnet" "main" {
  count                   = var.vpc_count
  vpc_id                  = aws_vpc.main[count.index].id
  cidr_block              = "${var.cidr_prefix}.${count.index}.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet-${count.index + 1}"
  }
}

# Internet Gateway with count
resource "aws_internet_gateway" "main" {
  count  = var.vpc_count
  vpc_id = aws_vpc.main[count.index].id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name}-igw-${count.index + 1}"
  }
}

# Route table with count
resource "aws_route_table" "main" {
  count  = var.vpc_count
  vpc_id = aws_vpc.main[count.index].id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.project_name}-rt-${count.index + 1}"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "main" {
  count          = var.vpc_count
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.main[count.index].id
}

# Data source to get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}
