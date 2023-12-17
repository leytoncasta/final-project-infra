/* 
Este es el archivo principal de terraforn, donde defino los recursos 
y configuraciones. Ejemplo: Configuraciones del proveedor y definicones 
de recursos
*/

# ---------------------------------------------------------------------
// Configuración de un S3 bucket
resource "aws_s3_bucket" "bucket_braves" {
  bucket = "s3-bucket-braves" // Especificamos el nombre para el S3 bucket
}

# ---------------------------------------------------------------------
// Configuración Origin Access Identity (OAI)
resource "aws_cloudfront_origin_access_identity" "origin_access_identity_braves" {
  comment = "origin access identity" // Especificamos descripción del Cloud Front OAI
}

# ---------------------------------------------------------------------
// Configuración política bucket s3
resource "aws_s3_bucket_policy" "bucket_policy_braves" {
  bucket = aws_s3_bucket.bucket_braves.bucket      // Especificamos el nombre del bucket al cual la política estará sujeta
  policy = jsonencode({                            // Especificamos configuración de la política en documento JSON
    Version = "2012-10-17",                        // Version de la política
    Id      = "PolicyForCloudFrontPrivateContent", // Identificador de la política
    Statement = [                                  // Matriz de declaración de política
      {
        Effect = "Allow", // Especifica si la declaración permite o deniega la política
        Principal = {     // Especifica el AWS entity (CloudFron OAI) para el cual la política grant permisos
          AWS = aws_cloudfront_origin_access_identity.origin_access_identity_braves.iam_arn
        },
        Action   = "s3:GetObject",                         // Especifica la acción permitida o denegada. En este caso permite "s3:GetObject"
        Resource = "${aws_s3_bucket.bucket_braves.arn}/*", // Especifica el nombre de los recursos de amazon (ARN) para el cual aplica la política. En este caso aplica para todos los objetos en el s3 
      },
    ],
  })
}

# ---------------------------------------------------------------------
// Configurar a cloudFront distribution
resource "aws_cloudfront_distribution" "clodFront_distribution_braves" {
  origin {                                                                // Especifica el origen de la configuración para cloudFront distribution. Este incluye S3 bucket para el cual cloudFront recupera información
    domain_name = aws_s3_bucket.bucket_braves.bucket_regional_domain_name // Dombre de dominio del s3 bucket
    origin_id   = "braves-s3-bucket"                                      // Identificador único del origen
  }
  enabled             = true                             // Especifica si el cloudfront distribution está habilitado
  is_ipv6_enabled     = true                             // Especifica si la distribución está habilitada para IPv6
  comment             = "braves cloudFront distribution" // Descripción del cloudFron distribution
  default_root_object = var.default_root_object          // Valor por default del objeto de origen

  default_cache_behavior {                        // Especificación comportamiento por defecto del cache para cloudFormation distribution
    allowed_methods  = ["GET", "HEAD", "OPTIONS"] // Especifica los métodos http que son permitidos para el comportamiento por defecto del cache
    cached_methods   = ["GET", "HEAD", "OPTIONS"] //  Especifica los métodos http que son permitidos para la respuesta por defecto del cache
    target_origin_id = "braves-s3-bucket"         //Identificador del objetivo de origen (S3)

    forwarded_values {     // configuraciones de cloudFront para e manejo de query y cookies
      query_string = false // Deshabilitado reenvio de query al origen
      cookies {            // Deshabilitado reenvio de cookie al origen
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all" // Especifica el espectador de protolo de politica. En este caso, permite HTTP y HTTPS
    min_ttl                = 0           // mínimo tiempo de vida en caché de un objeto
    default_ttl            = 3600        // Tiempo por defecto de vida en caché de un objeto
    max_ttl                = 86400       // máximo tiempo de vida en caché de un objeto
  }

  restrictions {      // Especifica restricciones del cloudFront
    geo_restriction { // Especifica que no hay restricciones en ubicación geográfica
      restriction_type = "none"
    }
  }

  viewer_certificate {                    // Configuración del certificado del espectador. 
    cloudfront_default_certificate = true // Especifica el udo de los certificados por defecto del cloudFront
  }
}
