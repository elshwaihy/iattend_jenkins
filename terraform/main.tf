resource "aws_instance" "ubuntu-instance" {
  ami           = var.ami
  instance_type = "t3.micro"
  key_name      = aws_key_pair.UbuntuKP.key_name
  security_groups = ["${aws_security_group.UbuntuSG.name}"]

  # Add shell script to install Docker
  user_data = <<-EOF
                    #!/bin/bash
                    sudo apt-get update
                    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                    # Add Docker GPG key & repository
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                    # Update the package index and install Docker
                    sudo apt-get update
                    sudo apt-get install -y docker-ce
                    sudo systemctl start docker
                    sudo systemctl enable docker
                    # Add current user to Docker group
                    sudo groupadd docker
                    sudo usermod -aG docker $USER && newgrp docker
                    sudo chmod 777 /var/run/docker.sock
                    # Install Docker Compose
                    sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                    sudo chmod +x /usr/local/bin/docker-compose
                    # Add the public key to the authorized_keys file
                    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUpOdMPlVcmosy2HAV7NG97PTH3RI5JUVaC/e8ao26//DHsdwtaaSu2A+MXq8mLwNAwuYnGkghqF6ZxF066fWYITXcBmfUTRTn/NHahdMvyP60KvXo1KpndhNTOC3joM0rIxKNOcXUEdriHWHMzZuDlruznXdps0sWpPnvIY2Em3Z19NJF9LqKuvJ5U6ZEjUbxAStT1WZndlcIZcFr7LbdITRX8vXcKMTt3neqgMVrDzg1s65bAv7+odakpgkn+BlcM3PqJI6/peIhgr5lgRX5Houcjr+dHvcE6gWeATDgRnflKh2pkShhHC0RnJRy9rr+LV/x3p3+m6qzWv703hJTDyRrza8yCKe9mIDSPRVYbpE55Es6QkrwO4ONxdS6D01Jx4If5a1N5ZidRWqxtPy3/VMToIvuHxwAnnWMgLTYlqiedpV5BRIlNOo+g0l/Im+apfMgUD4tMwvYwyVojwWvCszQ9ygbfbb3cW/eOgdM70lPX674JY/xVSZyaT4/DEwLrbLsrYnZQvIOn6EE4QTvACkyHxsJP6a7FIEUQSphqOUtNdBvRdVyE0mRyxQLgVGDAsM6tNEubsjltIUbEOB+sl9RmPIvqjDIJ2YcehJAnuTunJa+p5RWuGWX2X6CyK2coguTgttffWVfIdDV/FMz+sZTDxXIdYm7v/D6PWE56Q== jenkins@ubuntu" >> /home/ubuntu/.ssh/authorized_keys
                  EOF

  tags  = {
    Name  = "Ubuntu-EC2"
  }

}
