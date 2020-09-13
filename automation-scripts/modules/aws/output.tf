output "vpc_id" {
    value = aws_vpc.backend_network.id
}

output "public_route_table_id" {
    value = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
    value = aws_route_table.private_route_table.id
}

output "private_subnet_id" {
    value = aws_subnet.private_subnets.0.id
}
