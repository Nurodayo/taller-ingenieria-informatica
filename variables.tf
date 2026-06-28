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
