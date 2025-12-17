provider "aws" {
  region = "us-east-2" # Asegúrate de que coincida con tu región anterior
}

resource "aws_security_group" "sg_proyecto_final" {
  name        = "sg_proyecto_final"
  description = "Permitir trafico para App y Monitoreo"

  # SSH para Deploy
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP para Frontend
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Grafana (Observabilidad) - REQUISITO CRÍTICO
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_proyecto" {
  ami           = "ami-0fb653ca2d3203ac1" # Ubuntu 22.04 LTS en us-east-2
  instance_type = "t3.small"               # Recomendado para soportar el monitoreo
  key_name      = "y672dtAFCT"            # Tu llave pem (sin el .pem)
  vpc_security_group_ids = [aws_security_group.sg_proyecto_final.id]

  tags = {
    Name = "EC2-Proyecto-Final-DevOps"
  }
}

output "public_ip" {
  value = aws_instance.ec2_proyecto.public_ip
}
