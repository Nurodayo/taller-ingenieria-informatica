## Docker 

resource "aws_ecr_repository" "app" {
  name = "var.project"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "terraform_data" "docker_build" {
  depends_on = [
    aws_ecr_repository.app
  ]

  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ${data.aws_region.current.name} | \
      docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com

      docker build -t mi-app .

      docker tag proyecto:1.2 ${aws_ecr_repository.app.repository_url}:1.2

      docker push ${aws_ecr_repository.app.repository_url}:1.2
      EOF
  }

  triggers_replace = {
    dockerfile = filesha256("${path.module}/Dockerfile")
    dist = sha256(join("", [
      for f in fileset("${path.module}/frontend/dist", "**") :
      filesha256("${path.module}/frontend/dist/${f}")
    ]))
  }
}


## Networking

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = { Name = "${var.project}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

## Subnets

## creacion de ambas subnets
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.project}-${each.key}"
  }
}

## asociacion de las subnets
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

## Security groups 
## no se si deberian ser creados con un for each pero lo dejare para el futuro
## solo cambia el ingress y los nombres

resource "aws_security_group" "lambda" {
  name   = "lambda-sg"
  vpc_id = aws_vpc.main.id


  egress {
    from_port   = var.egress.from_port
    to_port     = var.egress.to_port
    protocol    = var.egress.protocol
    cidr_blocks = var.egress.cidr_blocks
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.project}-alb"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.ingress.from_port
    to_port     = var.ingress.to_port
    protocol    = var.ingress.protocol
    cidr_blocks = var.ingress.cidr_blocks
  }

  egress {
    from_port   = var.egress.from_port
    to_port     = var.egress.to_port
    protocol    = var.egress.protocol
    cidr_blocks = var.egress.cidr_blocks
  }
}

resource "aws_security_group" "fargate" {
  name   = "fargate-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = var.ingress.from_port
    to_port         = var.ingress.to_port
    protocol        = var.ingress.protocol
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = var.egress.from_port
    to_port     = var.egress.to_port
    protocol    = var.egress.protocol
    cidr_blocks = var.egress.cidr_blocks
  }

}

## IAM Roles and policies ## es muy similar al ecs_taskrole solo que difiere en una linea

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

## Task roles
## s3 roles and policies

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ecs_s3_policy" {
  name = "ecsS3Access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.datos.arn,
          "${aws_s3_bucket.datos.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_s3_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_s3_policy.arn
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = "${aws_ecr_repository.app.repository_url}:1.2"

      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_iam_role" "lambda_role" {
  name = "lambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

## ECS

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-cluster"
}

## TG

resource "aws_lb_target_group" "app" {
  name        = "${var.project}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

## ALB 

resource "aws_lb" "app" {
  name               = "my-app-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public["a"].id, aws_subnet.public["b"].id]
}

## Listener 

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

## Conectar ECS a ALB

resource "aws_ecs_service" "app" {
  name            = "my-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = [aws_subnet.public["a"].id, aws_subnet.public["b"].id]
    security_groups  = [aws_security_group.fargate.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "app"
    container_port   = 80
  }
}

## Bucket S3 

resource "aws_s3_bucket" "datos" {
  bucket = "${var.project}-datos-10"
}

resource "aws_s3_object" "assets" {
  for_each = fileset("${path.module}/bucket", "**")

  bucket = aws_s3_bucket.datos.id
  key    = each.value
  source = "${path.module}/bucket/${each.value}"

  etag = filemd5("${path.module}/bucket/${each.value}")
}

## Tienen que ser publicos para que podamos ver a nuestros choferes
## somos los unicos que podemos subir imagenes al bucket pero todos lo pueden ver

resource "aws_s3_bucket_public_access_block" "datos" {
  bucket = aws_s3_bucket.datos.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "datos_public" {
  bucket = aws_s3_bucket.datos.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.datos.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.datos]
}


## API Gateway 

resource "aws_apigatewayv2_api" "backend" {
  name          = "backend-paparuta"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins  = ["*"] # inseguro
    allow_methods  = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers  = ["Content-Type", "Authorization"]
    expose_headers = ["*"]
    max_age        = 300
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.backend.id

  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.reservas.invoke_arn
  payload_format_version = "2.0"
}

## TOKEN de seguridad
resource "aws_lambda_permission" "authorizer" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_authorizer" "token" {
  api_id = aws_apigatewayv2_api.backend.id

  name = "token-authorizer"

  authorizer_type = "REQUEST"

  authorizer_uri = aws_lambda_function.authorizer.invoke_arn

  identity_sources = [
    "$request.header.Authorization"
  ]

  authorizer_payload_format_version = "2.0"
  enable_simple_responses           = true
}

## ENDPOINTS RESERVAS
## Podria hacer un objeto para cada endpoint y hacer un for each para crearlos.

resource "aws_apigatewayv2_route" "post_reservas" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "POST /reservas"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

resource "aws_apigatewayv2_route" "get_reservas" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "GET /reservas"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

resource "aws_apigatewayv2_route" "getid_reservas" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "GET /reservas/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

resource "aws_apigatewayv2_route" "put_reservas" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "PUT /reservas/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

resource "aws_apigatewayv2_route" "delete_reservas" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "DELETE /reservas/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

## ENDPOINTS RECORRIDOS
resource "aws_apigatewayv2_route" "post_recorridos" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "POST /recorridos"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

resource "aws_apigatewayv2_route" "get_recorridos" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "GET /recorridos"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

resource "aws_apigatewayv2_route" "getid_recorridos" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "GET /recorridos/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

resource "aws_apigatewayv2_route" "put_recorridos" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "PUT /recorridos/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

resource "aws_apigatewayv2_route" "delete_recorridos" {
  api_id = aws_apigatewayv2_api.backend.id

  route_key = "DELETE /recorridos/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.token.id
}

##

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.backend.id

  name        = "$default"
  auto_deploy = true
}


resource "aws_lambda_permission" "apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reservas.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.backend.execution_arn}/*/*"
}

## Dominio custom de la API 

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = var.api_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.api.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_acm_certificate" "api" {
  domain_name       = var.api_domain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn = aws_acm_certificate.api.arn
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_apigatewayv2_api.backend.id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = aws_apigatewayv2_stage.default.id
}

## DynamoDB 
## Yo creo que antes de entregar esta parte podriamos separarlo en otro archivo

## Tables 

resource "aws_dynamodb_table" "recorridos" {
  name         = "recorridos"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "reservas" {
  name         = "reservas"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_iam_policy" "lambda_dynamodb" {
  name = "LambdaDynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      Resource = [
        aws_dynamodb_table.reservas.arn,
        aws_dynamodb_table.recorridos.arn
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb.arn
}

## Lambda 

resource "aws_lambda_function" "reservas" {
  function_name = "reservas"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.12"
  handler = "lambda_function.lambda_handler"

  filename         = "./lambda/lambda.zip"
  source_code_hash = filebase64sha256("./lambda/lambda.zip")

  environment {
    variables = {
      RESERVAS_TABLE   = aws_dynamodb_table.reservas.name
      RECORRIDOS_TABLE = aws_dynamodb_table.recorridos.name
    }
  }
}

resource "aws_lambda_function" "authorizer" {
  function_name = "paparuta-authorizer"

  role = aws_iam_role.ecs_task_role.arn

  # runtime, role, handler, filename, etc.

  environment {
    variables = {
      API_TOKEN = var.api_token
    }
  }
}

resource "aws_iam_policy" "lambda_logs" {
  name = "LambdaCloudWatchLogs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}
