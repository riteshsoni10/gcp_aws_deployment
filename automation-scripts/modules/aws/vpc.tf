## AWS Availability Zones

data "aws_availability_zones" "available_zones" {
    state = "available"
}

## Backend Database Network
resource "aws_vpc" "backend_network" {
    cidr_block = var.vpc_cidr_block
    tags       = {
            Name = "Backend-Network"
    } 
}

## Subnets

resource "aws_subnet" "public_subnets" {
    count                   = length(data.aws_availability_zones.available_zones.names)
    cidr_block              = cidrsubnet(var.vpc_cidr_block,8,count.index)
    vpc_id                  = aws_vpc.backend_network.id
    availability_zone       = element(data.aws_availability_zones.available_zones.names,count.index)
    map_public_ip_on_launch = true
    tags = {
        Name  = "Public Subnet - ${element(data.aws_availability_zones.available_zones.names,count.index)}"
    }

    depends_on =[
        aws_vpc.backend_network
    ]

}

resource "aws_subnet" "private_subnets" {
    count  = length(data.aws_availability_zones.available_zones.names)
    cidr_block  = cidrsubnet(var.vpc_cidr_block,8,"${10+count.index}")
    vpc_id      = aws_vpc.backend_network.id
    availability_zone  = element(data.aws_availability_zones.available_zones.names,count.index)
    tags  = {
        Name  = "Private Subnet - ${element(data.aws_availability_zones.available_zones.names,count.index)}"
    }

    depends_on = [
        aws_vpc.backend_network
    ]
}

## Public IP for NAT Gateway

resource "aws_eip" "nat_public_ip"{
    vpc    = true

    tags = {
        Name = "NAT -GW Public IP"
    }
}

