provider "aws" {
  region = "us-east-2" 
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

  # Grafana (Observabilidad) 
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
  ami           = "ami-0fb653ca2d3203ac1" 
  instance_type = "t3.small"               
  key_name      = "y672dtAFCT"            
  vpc_security_group_ids = [aws_security_group.sg_proyecto_final.id]

  # Script de automatización para instalar Docker y Docker Compose
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "EC2-Proyecto-Final-DevOps"
  }
}

output "public_ip" {
  value = aws_instance.ec2_proyecto.public_ip
}
