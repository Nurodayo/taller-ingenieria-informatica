Estamos usando la pagina anterior para probar

# Hito 1 - Infraestructura aws con Terraform

## Descripción

Este proyecto implementa una infraestructura en AWS utilizando **Terraform** como herramienta de Infraestructura como Código (IaC).

La solución despliega una aplicación web ejecutándose en **Amazon ECS Fargate**, accesible mediante un **Application Load Balancer (ALB)**, dentro de una **VPC personalizada** con dos subredes públicas. Además, se configura un **bucket Amazon S3** para almacenamiento y los roles IAM necesarios para la ejecución de las tareas ECS.

---

# Arquitectura

```
                    Internet
                        │
                        ▼
          Application Load Balancer
                        │
                        ▼
                Amazon ECS Fargate
                        │
                        ▼
                  Amazon S3 Bucket

        VPC (10.0.0.0/16)
        ├───────────────┐
        │               │
        ▼               ▼
   Subnet A        Subnet B
10.0.1.0/24     10.0.2.0/24
```

---

# Recursos creados

El proyecto crea automáticamente los siguientes recursos en AWS:

- VPC personalizada
- Internet Gateway
- Tabla de rutas pública
- Dos subredes públicas
- Security Groups
- Roles y políticas IAM
- ECS Cluster
- ECS Task Definition
- ECS Service (Fargate)
- Application Load Balancer
- Target Group
- Listener HTTP
- Bucket Amazon S3

---

# Estructura del proyecto

```
.
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── README.md
├── .gitignore
├── Dockerfile
├── .terraform.lock.hcl
├──── src/
├────── assets/
├────── index.html
├────── script.js
└────── styles.css
```

---

# Variables

| Variable          | Descripción                            |
| ----------------- | -------------------------------------- |
| `region`          | Región de aws                          |
| `project`         | Nombre del proyecto                    |
| `vpc_cidr`        | Bloque cidr de la vpc                  |
| `public_subnets`  | Configuración de las subredes públicas |
| `container_image` | Imagen Docker utilizada por ecs        |
| `desired_count`   | Cantidad de tareas ecs                 |
| `ingress`         | Regla de entrada por defecto           |
| `egress`          | Regla de salida por defecto            |

---

# Outputs

Una vez desplegada la infraestructura, Terraform entrega información útil como:

- ID de la VPC
- ID del Internet Gateway
- ID de la tabla de rutas
- IDs de las subredes
- IDs de los Security Groups
- DNS público del Application Load Balancer
- Nombre del bucket S3
- Nombre del clúster ECS
- Nombre del servicio ECS
- ARN del Target Group
- ARN de la Task Definition
- ARN de los roles IAM

---

# Requisitos

- Terraform 1.6 o superior
- Cuenta de AWS
- AWS CLI configurado
- Credenciales válidas con permisos para crear recursos

---

# Despliegue

Inicializar Terraform:

```bash
terraform init
```

Validar la configuración:

```bash
terraform validate
```

Formatear el código:

```bash
terraform fmt
```

Visualizar el plan de ejecución:

```bash
terraform plan
```

Crear la infraestructura:

```bash
terraform apply
```

Eliminar la infraestructura:

```bash
terraform destroy
```

---

# Tecnologías utilizadas

- Terraform
- Amazon VPC
- Amazon ECS Fargate
- Application Load Balancer
- Amazon S3
- AWS IAM
