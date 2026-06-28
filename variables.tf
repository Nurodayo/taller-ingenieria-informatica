variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Región de AWS utilizada para el proyecto"
}
variable "project" {
  type        = string
  default     = "hito1-leo-emi"
  description = "Nombre del proyecto"
}
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Bloque cidr de la VPC"
}
variable "container_image" {
  type        = string
  default     = "585768150938.dkr.ecr.us-east-1.amazonaws.com/hito1:1.0"
  description = "Imagen Docker del contenedor"
}
variable "desired_count" {
  type        = number
  default     = 1
  description = "Número de tareas ECS"
}
variable "public_subnets" {
  description = "Subredes públicas"
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    a = {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
    }
    b = {
      cidr = "10.0.2.0/24"
      az   = "us-east-1b"
    }
  }
}
variable "egress" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })

  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "ingress" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })

  default = {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
