provider "aws" {
  profile = var.profile
  region = "us-east-1"
}

resource "aws_security_group" "web_server" {
  name        = "web-server"
  description = "Allow incoming HTTP Connections"
  ingress {
    from_port   = 80
    to_port     = 80
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
resource "aws_instance" "web_server" {
  ami             = "ami-0e731c8a588258d0d"
  instance_type   = "t2.micro"
  key_name        = ""
  security_groups = ["${aws_security_group.web_server.name}"]
  user_data       = <<-EOF
    #!/bin/bash 
    sudo su
    yum update -y
    yum install httpd -y
    wget https://github.com/elijahops1/valentine.github.io/archive/refs/heads/main.zip
    unzip main.zip
    cp -r valentine.github.io/* /var/www/html/
    systemctl start httpd
    systemctl enable httpd
    EOF
  tags = {
    Name = "web_instance"
  }
}
