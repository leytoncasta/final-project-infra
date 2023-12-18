/* 
Este es el archivo principal de terraforn, donde defino los recursos 
y configuraciones. Ejemplo: Configuraciones del proveedor y definicones 
de recursos
*/

# ---------------------------------------------------------------------
// Definimos el proveedor de nube, y la región como una variable ya declarada
provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------
// Llamamos el módulo de VPC que ya creamos y pasamos los valores de las variables
module "vpc_braves" {
  source                       = "./modules/vpc"
  aws_region                   = var.aws_region
  cidr_block_sub1              = var.cidr_block_sub1
  cidr_block_sub2              = var.cidr_block_sub2
  cidr_block                   = var.cidr_block
  availability_zone_subnet_one = var.availability_zone_subnet_one
  availability_zone_subnet_two = var.availability_zone_subnet_two
}

# ---------------------------------------------------------------------
// Llamamos el output para imprimir el id de la VPC
output "vpc_id" {
  value = module.vpc_braves.aws_vpc_id
}

# ---------------------------------------------------------------------
// Llamamos el output para imprimir el id de la puerta de enlace
output "igw_id" {
  value = module.vpc_braves.aws_igw_id
}

# ---------------------------------------------------------------------
// Llamamos el output para imprimir el id de la sub-red uno
output "id_subnet_one" {
  value = module.vpc_braves.aws_subnet_one_id
}

# ---------------------------------------------------------------------
// Llamamos el output para imprimir el id de la sub-red dos
output "id_subnet_two" {
  value = module.vpc_braves.aws_subnet_two_id
}

# ---------------------------------------------------------------------
// Llamamos el output para imprimir el id del grupo de seguridad
output "id_security_group" {
  value = module.vpc_braves.aws_security_groups_id
}

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
// Llamamos el módulo de alb que ya creamos y pasamos los valores de las variables
module "alb_braves" {
  source                 = "./modules/alb"
  aws_vpc_id             = module.vpc_braves.aws_vpc_id
  aws_subnet_one_id      = module.vpc_braves.aws_subnet_one_id
  aws_security_groups_id = module.vpc_braves.aws_security_groups_id
  aws_subnet_two_id      = module.vpc_braves.aws_subnet_two_id
}

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
// Llamamos el módulo de ecs que ya creamos y pasamos los valores de las variables
module "ecs_braves" {
  source                 = "./modules/ecs"
  aws_security_groups_id = module.vpc_braves.aws_security_groups_id
  aws_subnet_one_id      = module.vpc_braves.aws_subnet_one_id
  aws_subnet_two_id      = module.vpc_braves.aws_subnet_two_id
  memory                 = var.memory
  cpu                    = var.cpu
  container_image        = var.container_image
}

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
// Llamamos el módulo de s3 que ya creamos y pasamos los valores de las variables
module "name" {
  source              = "./modules/s3"
  default_root_object = var.default_root_object
}
