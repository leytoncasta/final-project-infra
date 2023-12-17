/*
En este archivo vamos a declarar las variables que serán
usadas en nuestro archivo de configuración main.tf (módulo principal).
*/

# ---------------------------------------------------------------------
// Definimos variables para las unidades de cpu para tareas de FARGATE
variable "default_root_object" {
  description = "valor del objeto de origen"
  type = string
}