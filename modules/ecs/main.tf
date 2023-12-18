/* 
Este es el archivo principal de terraforn, donde defino los recursos 
y configuraciones. Ejemplo: Configuraciones del proveedor y definicones 
de recursos
*/

# ---------------------------------------------------------------------
// Creamos el IAM role
resource "aws_iam_role" "ecs_role_braves" {
  name = "iam-braves-role" // Nombre del IAM role



  assume_role_policy = jsonencode({ // Definición de politica del role
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com" // Servicio principal espeificado como entidad que puede asumir este rol
      }
    }]
  })
}

# ---------------------------------------------------------------------
// Creamos ecr
resource "aws_ecr_repository" "ecr_braves" {
  name = "ecr_repo_braves" // Nombre del ECr
}

# ---------------------------------------------------------------------
// Creamos un output de la url del ecr
output "repository_url" {
  value = aws_ecr_repository.ecr_braves.repository_url
}

# ---------------------------------------------------------------------
// Configuración de definición política para iam
resource "aws_iam_policy" "iam_policy_braves" {
  name        = "full-control-iam"                 // Nombre de la política iam
  description = "Proporcina full control para iam" // Descripción de la política iam
  policy = jsonencode({                            // Definición de política. Convierte terraform map en formato json
    Version = "2012-10-17"
    Statement = [{
      Action   = "iam:*", // Permite todas las acciones iam
      Effect   = "Allow",
      Resource = "*" // Permite actuar en todos los recursos
    }]
  })
}

# ---------------------------------------------------------------------
// Configuración de política para ecs
resource "aws_iam_policy" "ecs_policy_braves" {
  name        = "full-control-ecs"                  // Nombre de la política ecs
  description = "Proporciona full control para ecs" // Descripción de la política ecs
  policy = jsonencode({                             // Definición de política. Convierte terraform map en formato json
    Version = "2012-10-17"
    Statement = [{
      Action   = "ecs:*", // Permite todas las acciones ecs
      Effect   = "Allow",
      Resource = "*" // Permite actuar en todos los recursos
    }]
  })
}

# ---------------------------------------------------------------------
// Añadimos política iam al role IAM
resource "aws_iam_role_policy_attachment" "iam_attachment" {
  policy_arn = aws_iam_policy.iam_policy_braves.arn // Especifica el ARN (Amazon Resource Name) de la política iam que se quiere sujetar al role
  role       = aws_iam_role.ecs_role_braves.name    // Especifica el iam role al cual la política estará sujeta
}

# ---------------------------------------------------------------------
// Añadimos política ecs al role IAM
resource "aws_iam_role_policy_attachment" "ecs_attachment" {
  policy_arn = aws_iam_policy.ecs_policy_braves.arn // Especifica el ARN (Amazon Resource Name) de la política ecs que se quiere sujetar al role
  role       = aws_iam_role.ecs_role_braves.name    // Especifica el iam role al cual la política estará sujeta
}

# ---------------------------------------------------------------------
// Definimos la configuración del cluster ECS
resource "aws_ecs_cluster" "ecs_braves_final_project" {
  name = "ecs-braves" // Nombre del ECS Cluster
}

# ---------------------------------------------------------------------
// Creamos el task definition
resource "aws_ecs_task_definition" "ecs_task_definition_braves" {
  family                   = "final-project-family"           // Nombre de la familia del task definition. 
  network_mode             = "awsvpc"                         // Modo de red para la tarea. AWS VPC Networking mode
  requires_compatibilities = ["FARGATE"]                      // Tipo de compatibilidad, indicando que esta defnición de tarea es para FARGATE
  cpu                      = var.cpu                          // unidades de cpu requeridas para la tarea
  memory                   = var.memory                       // memoria requerida para la tarea
  execution_role_arn       = aws_iam_role.ecs_role_braves.arn // Se especifica de ARN (Amazon Resource Name) que debería ser asumido por la tarea de ECS

  container_definitions = jsonencode([{ // Container a correr como parte de la tarea
    name  = "container-braves"
    image = aws_ecr_repository.ecr_braves.repository_url // Especificamos la url del ECR
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

# ---------------------------------------------------------------------
// Creamos el ECS Service
resource "aws_ecs_service" "ecs_service_braves" {
  name            = "service-braves"                                       // Nombre del servicio de ECS
  cluster         = aws_ecs_cluster.ecs_braves_final_project.id            // ECS cluster en el que el servcio va a correr 
  task_definition = aws_ecs_task_definition.ecs_task_definition_braves.arn // Especimica de ARN de la ECS task definition para usar el servicio
  launch_type     = "FARGATE"                                              // Especifica el tipo de lanzamiento para el servvico
  desired_count   = 1                                                      // Especifica el número de tareas a correr en el servico

  network_configuration {                                            // Configuración de red para el servicio
    subnets         = [var.aws_subnet_one_id, var.aws_subnet_two_id] // Subredes en las que se plasma la tarea
    security_groups = [var.aws_security_groups_id]                   // Grupos de seguridad asociados con la tarea
  }
}
