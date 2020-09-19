output "vpc_id" {
    value = aws_vpc.backend_network.id
}

output "public_route_table_id" {
    value = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
    value = aws_route_table.private_route_table.id
}

output "public_subnet_cidrs" {
	value = aws_subnet.public_subnets.*.cidr_block 
}


output "public_subnets"{
    value          = aws_subnet.public_subnets.*.id
}


output "private_subnets" {
    value          = aws_subnet.private_subnets.*.id
}


output "private_subnet_cidrs"{
    value = aws_subnet.private_subnets.*.cidr_block
}


output "nat_public_ip" {
	value = aws_eip.nat_public_ip.public_ip 
}
