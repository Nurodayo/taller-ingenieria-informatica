output "vpc_id" {
  value       = aws_vpc.main.id
  description = "id de la vpc"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "id del internet gateway"
}

output "route_table_id" {
  value       = aws_route_table.public.id
  description = "id de la tabla de rutas pública"
}

output "subnet_ids" {
  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
  description = "ids de las subredes públicas"
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

# output "api_url" {
#   value = aws_apigatewayv2_stage.default.invoke_url
#   description = "url de la api"
# }

output "api_gateway_id" {
  description = "ID del API Gateway HTTP"
  value       = aws_apigatewayv2_api.backend.id
}

output "api_gateway_endpoint" {
  description = "Endpoint por defecto del API Gateway"
  value       = aws_apigatewayv2_api.backend.api_endpoint
}

output "api_execution_arn" {
  description = "Execution ARN del API Gateway"
  value       = aws_apigatewayv2_api.backend.execution_arn
}

output "stage_name" {
  description = "Nombre del stage"
  value       = aws_apigatewayv2_stage.default.name
}



output "certificate_arn" {
  description = "ARN del certificado ACM"
  value       = aws_acm_certificate.api.arn
}

output "api_custom_url" {
  description = "URL de la API usando el dominio personalizado"
  value       = "https://${aws_apigatewayv2_domain_name.api.domain_name}"
}

## DYNAMO DB 

output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.reservas.function_name
}

output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.reservas.arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN de la función Lambda"
  value       = aws_lambda_function.reservas.invoke_arn
}

output "reservas_table_name" {
  description = "Nombre de la tabla DynamoDB de reservas"
  value       = aws_dynamodb_table.reservas.name
}

output "reservas_table_arn" {
  description = "ARN de la tabla DynamoDB de reservas"
  value       = aws_dynamodb_table.reservas.arn
}

output "recorridos_table_name" {
  description = "Nombre de la tabla DynamoDB de recorridos"
  value       = aws_dynamodb_table.recorridos.name
}

output "recorridos_table_arn" {
  description = "ARN de la tabla DynamoDB de recorridos"
  value       = aws_dynamodb_table.recorridos.arn
}

output "lambda_role_name" {
  description = "Nombre del rol IAM de la Lambda"
  value       = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  description = "ARN del rol IAM de la Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_dynamodb_policy_arn" {
  description = "ARN de la política IAM para acceso a DynamoDB"
  value       = aws_iam_policy.lambda_dynamodb.arn
}

output "lambda_logs_policy_arn" {
  description = "ARN de la política IAM para CloudWatch Logs"
  value       = aws_iam_policy.lambda_logs.arn
}

## INSTRUCCIONES DOMINIO
output "custom_domain_name" {
  description = "Nombre del dominio personalizado"
  value       = aws_apigatewayv2_domain_name.api.domain_name
}

output "custom_domain_target" {
  description = "Target DNS del dominio personalizado"
  value       = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
}

output "dns_configuration_instructions" {
  description = "Instrucciones para configurar el DNS del dominio"

  value = <<EOT
Configura un registro CNAME con los siguientes valores:

Nombre (Host): ${aws_apigatewayv2_domain_name.api.domain_name}
Tipo: CNAME
Destino: ${aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name}

Una vez propagado el DNS, la API estará disponible en:
https://${aws_apigatewayv2_domain_name.api.domain_name}
EOT
}
