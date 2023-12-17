/*
En este archivo vamos a declarar las variables que serán
usadas en nuestro archivo de configuración main.tf (módulo principal).
*/

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

# ---------------------------------------------------------------------
// Definimos una variable para contener el id de la VPC
variable "aws_vpc_id" {
  description = "id VPC"
  type        = string
}
