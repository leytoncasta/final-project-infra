/*
En este archivo vamos a declarar las variables que serán
usadas en nuestro archivo de configuración main.tf (módulo principal).
*/

# ---------------------------------------------------------------------
// Definimos variables para las unidades de cpu para tareas de FARGATE
variable "cpu" {
  description = "valor cpu FARGATE"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos variables para la memoria en Mb para FARGATE
variable "memory" {
  description = "valor memoria FARGATE"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos variables para la imagen del contenedor
variable "container_image" {
  description = "imagen del contenedor"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos una variable para contener el id del grupo de recursos
variable "aws_security_groups_id" {
  description = "id grupo de seguridad"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos una variable para contener el id de las subred uno
variable "aws_subnet_one_id" {
  description = "id subred uno"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos una variable para contener el id de las subred dos
variable "aws_subnet_two_id" {
  description = "id subred dos"
  type        = string
}
