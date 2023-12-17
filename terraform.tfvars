/*
Este archivo es algo parecido al de variables.tf. Sin embargo, 
el objetivo de este es guardar valores de variables que pueden 
ser usadas para parametrizar nuestras configuraciones de infraestructura
*/

# ---------------------------------------------------------------------
// Definimos las variables del módulo de VPC
aws_region                   = "us-east-2"   //region
cidr_block                   = "10.0.0.0/22" // red máscara 22"
cidr_block_sub1              = "10.0.1.0/24" // Máscara 24 - subred uno
cidr_block_sub2              = "10.0.2.0/24" // Mascara 24 - subred dos
availability_zone_subnet_one = "us-east-2a"  // Zona de disponibilidad subred uno (Data Center)
availability_zone_subnet_two = "us-east-2b"  // Zona de disponibilidad subred dos (Data Center)

# ---------------------------------------------------------------------
// Definimos las variables del módulo de ecs
cpu             = "256"
memory          = "512"
container_image = "node:latest"

# ---------------------------------------------------------------------
// Definimos las variables del módulo de s3
default_root_object = "index.html"

