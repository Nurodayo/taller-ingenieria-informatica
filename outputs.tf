output "vpc_id" {
  value = aws_vpc.main.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "route_table_id" {
  value = aws_route_table.public.id
}

output "subnet_ids" {
  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
}

output "security_group_ids" {
  value = {
    lambda  = aws_security_group.lambda.id
    alb     = aws_security_group.alb.id
    fargate = aws_security_group.fargate.id
  }
}
