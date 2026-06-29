output "vpc_id" {
  value = aws_vpc.main.id
  description = "id de la vpc"
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
  description = "id del internet gateway"
}

output "route_table_id" {
  value = aws_route_table.public.id
  description = "id de la tabla de rutas pública"
}

output "subnet_ids" {
  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
  description = "id de las subredes públicas"
}

output "security_group_ids" {
  value = {
    lambda  = aws_security_group.lambda.id
    alb     = aws_security_group.alb.id
    fargate = aws_security_group.fargate.id
  }
  description = "id de los security groups creados"
}
output "alb_dns_name" {
  value       = aws_lb.app.dns_name
  description = "dns público del application load balancer"
}
output "bucket_name" {
  value       = aws_s3_bucket.datos.id
  description = "nombre del bucket s3"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "nombre del cluster ecs"
}

output "ecs_service_name" {
  value       = aws_ecs_service.app.name
  description = "nombre del service ecs"
}

output "target_group_arn" {
  value       = aws_lb_target_group.app.arn
  description = "arn del target group del alb"
}

output "task_definition_arn" {
  value       = aws_ecs_task_definition.app.arn
  description = "arn de la definición de la task definition"
}

output "iam_execution_role_arn" {
  value       = aws_iam_role.ecs_execution_role.arn
  description = "arn del execution role de ecs"
}

output "iam_task_role_arn" {
  value       = aws_iam_role.ecs_task_role.arn
  description = "arn del task role de ecs"
}