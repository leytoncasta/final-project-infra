/* 
    Este archivo sirve para mostrar valores de cada
    una de las configuraciones hechas en el archivo
    de configuración. Estos valores se muestran después
    del terraform apply
*/

# ---------------------------------------------------------------------
// Definimos output para el id de la vpc
output "aws_vpc_id" {
  value = aws_vpc.vpc_final_project.id
}

# ---------------------------------------------------------------------
// Definimos output para el id de la vpc
output "aws_igw_id" {
  value = aws_internet_gateway.igw_final_project.id
}

# ---------------------------------------------------------------------
// Definimos output para el id de la subred uno
output "aws_subnet_one_id" {
  value = aws_subnet.public_subnet_one.id
}

# ---------------------------------------------------------------------
// Definimos output para el id de la subred dos
output "aws_subnet_two_id" {
  value = aws_subnet.public_subnet_two.id
}

# ---------------------------------------------------------------------
// Definimos output para el id de los security groups
output "aws_security_groups_id" {
  value = aws_security_group.sg_final_project.id
}
