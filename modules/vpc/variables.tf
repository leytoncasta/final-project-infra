/*
En este archivo vamos a declarar las variables que serán
usadas en nuestro archivo de configuración main.tf de 
nuestro módulo de VPC.
*/

# ---------------------------------------------------------------------
// Definimos la variable "region", damos una descripción, 
//definimos el tipo de variable
variable "aws_region" {
  description = "Región a desplegar"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos una variables para indicar en que zona de la region se desplegarála subnet
variable "availability_zone_subnet_one" {
  description = "zona de disponibilidad subred uno"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos una variables para indicar en que zona de la region se desplegarála subnet
variable "availability_zone_subnet_two" {
  description = "zona de disponibilidad subred dos"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos una variables para cargar una dirección IP por default.
variable "cidr_block" {
  description = "Dirección IP"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos una variables para cargar la sub-red uno
variable "cidr_block_sub1" {
  description = "Sub-red uno"
  type        = string
}

# ---------------------------------------------------------------------
// Definimos una variables para cargar la sub-red dos
variable "cidr_block_sub2" {
  description = "Sub-red dos"
  type        = string
}
