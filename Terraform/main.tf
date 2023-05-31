# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Define the EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  vpc_security_group_ids = ["my-security-group"]
}

# Install Docker, Docker Compose and Portainer on the EC2 instance
resource "aws_cloudinit_instance" "example" {
  instance_id = aws_instance.example.id
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io docker-compose
              docker run -d -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
              EOF
}

# Output the public IP address of the instance and the URL for Portainer
output "public_ip" {
  value = aws_instance.example.public_ip
}

output "portainer_url" {
  value = "http://${aws_instance.example.public_ip}:9000"
}
