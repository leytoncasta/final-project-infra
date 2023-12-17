/* 
Este es el archivo principal de terraform, donde defino los recursos 
y configuraciones del alb
*/

# ---------------------------------------------------------------------
// Configuramos el balanceador de carga
resource "aws_lb" "lb_braves" {
  name                       = "balanceador-final-project"                    // Nombre del balanceador de carga
  internal                   = false                                          //Balanceador de carga externo
  load_balancer_type         = "application"                                  // Tipo de balanceador para aplicación
  security_groups            = [var.aws_security_groups_id]                   // Id de grupos de seguridad asociados al balanceador
  subnets                    = [var.aws_subnet_one_id, var.aws_subnet_two_id] // Ids de subredes en las cuales será desplegado el balanceador
  enable_deletion_protection = false                                          // Se deshabilita la protección contra borrado
}

# ---------------------------------------------------------------------
// Configuramos el target group
resource "aws_lb_target_group" "lb_target_group_braves" {
  name     = "target-group-final-project" // Se especifica el nombre del target group
  port     = 80                           // Puerto por el cual se recibe el tráfico
  protocol = "HTTP"                       // Protocolo para el routing del tráfico (HTTP)
  vpc_id   = var.aws_vpc_id               // Id de la VPC ya configurada
}

# ---------------------------------------------------------------------
// Configuración listener para el balanceador de carga 
resource "aws_lb_listener" "lb_listener_braves" {
  load_balancer_arn = aws_lb.lb_braves.arn // Se especifica de ARN (Amazon Resource Name) del balanceador al cual el listener está sujeto
  port              = 80                   // Puerto por el cual el listener estará atento al tráfico entrante
  protocol          = "HTTP"               // Protocolo usado por el listener para el tráfico entrante

  default_action { // Bloque de acciones por defecto del listener. Si ninguna regla ccoincide, una respuesta será enviada
    target_group_arn = aws_lb_target_group.lb_target_group_braves.arn // Se especifica de ARN (Amazon Resource Name) del target group a el cual el listener remite peticiones de entrada
    type             = "forward"
  }
}
