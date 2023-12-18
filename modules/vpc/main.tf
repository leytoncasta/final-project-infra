/* 
Este es el archivo principal de terraforn, donde defino los recursos 
y configuraciones de la capa de red de AWS.
*/

# ---------------------------------------------------------------------
//Definimosel tipo de recurso y el nombre con el que se identifica la VPC
resource "aws_vpc" "vpc_final_project" {
  cidr_block           = var.cidr_block
  enable_dns_support   = false // No asignar resolución de DNS en la VPC. No usa nombres DNS privados para comunicarse entre instancias
  enable_dns_hostnames = false // No asignar de manera automática hostnames a instancias en la VPC
  // Etiqueta para identificar vpc
  tags = {
    Name = "vpc_braves"
  }
}

# ---------------------------------------------------------------------
// Definimos la puerta de enlace. 
resource "aws_internet_gateway" "igw_final_project" {
  vpc_id = aws_vpc.vpc_final_project.id // Traemos el identificador único de la VPC para la configuración del gateway
  // Etiqueta para identificar iwg
  tags = {
    Name = "igw_braves"
  }
}
# ---------------------------------------------------------------------
//Definimos la configuración de la sub-red uno
resource "aws_subnet" "public_subnet_one" {
  vpc_id                  = aws_vpc.vpc_final_project.id     // Traemos el identificador único de la VPC para la configuración la sub-red uno
  cidr_block              = var.cidr_block_sub1              // Llamamos la variable de la subnet uno para definir dirección IP
  availability_zone       = var.availability_zone_subnet_one // Llamamos la región en la que se desplega
  map_public_ip_on_launch = true                             // Automáticamente asignará una ip pública en el lanzamiento
  // Etiqueta para identificar la subred uno
  tags = {
    Name = "subnetOne_braves"
  }
}

# ---------------------------------------------------------------------
//Definimos la configuración de la sub-red dos
resource "aws_subnet" "public_subnet_two" {
  vpc_id                  = aws_vpc.vpc_final_project.id     // Traemos el identificador único de la VPC para la configuración la sub-red dos
  cidr_block              = var.cidr_block_sub2              // Llamamos la variable de la subnet dos para definir dirección IP
  availability_zone       = var.availability_zone_subnet_two // Llamamos la región en la que se desplega
  map_public_ip_on_launch = true                             // Automáticamente asignará una ip pública en el lanzamiento
  // Etiqueta para identificar la subred dos
  tags = {
    Name = "subnetTwo_braves"
  }
}

# ---------------------------------------------------------------------
//Definimos tabla de enrutamiento para subredes públicas
resource "aws_route_table" "rt_final_project" {
  vpc_id = aws_vpc.vpc_final_project.id // Traemos el identificador único de la VPC para configurar tabla de enrutamiento
  route {
    cidr_block = "0.0.0.0/0"                               // Todas las direcciones IP cualquier destino
    gateway_id = aws_internet_gateway.igw_final_project.id // Traemos el identificador único de nuestra puerta de enlace
  }

  tags = {
    Name = "routeTable_braves"
  }
}

# ---------------------------------------------------------------------
// Asociamos las sub-red uno con la tabla de enrutamiento
resource "aws_route_table_association" "association_subnet_one" {
  subnet_id      = aws_subnet.public_subnet_one.id     // Llamamos el identificador único de la sub-red pública uno
  route_table_id = aws_route_table.rt_final_project.id //Llamamos el identificador único de la tabla de enrutamiento
}

# ---------------------------------------------------------------------
// Asociamos las sub-rede dos con la tabla de enrutamiento
resource "aws_route_table_association" "association_subnet_two" {
  subnet_id      = aws_subnet.public_subnet_two.id     // Llamamos el identificador único de la sub-red pública dos
  route_table_id = aws_route_table.rt_final_project.id //Llamamos el identificador único de la tabla de enrutamiento
}

# ---------------------------------------------------------------------
// Definimos los grupos de seguridad
resource "aws_security_group" "sg_final_project" {
  vpc_id = aws_vpc.vpc_final_project.id

  // Definimos configuración de salida
  egress {
    from_port   = 0             // Aplica para todos los puertos origen
    to_port     = 0             // Aplica para todos los puertos destino
    protocol    = "-1"          // Protocolo de comunicación (Cualquier protocolo)
    cidr_blocks = ["0.0.0.0/0"] //Aplica para cualquier dirección IP destino
  }

  // Definimos configuración de llegada
  ingress {
    from_port   = 80            // Puero origen 80
    to_port     = 80            // Puerto destino 80
    protocol    = "tcp"         // Protocolo de comunicción tcp
    cidr_blocks = ["0.0.0.0/0"] //Aplica para cualquier dirección IP origen
  }
}

