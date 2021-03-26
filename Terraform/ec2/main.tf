resource "aws_instance" "web-server-instance" {
  ami               = "ami-0ed17ff3d78e74700"
  instance_type     = "t3.medium"
  availability_zone = "eu-north-1b"
  key_name          = "jenkins-key"

  network_interface {
    device_index         = 0
    network_interface_id = var.net_id
  }


  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                #install-awscli
                sudo apt install -y unzip
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                unzip awscliv2.zip
                sudo ./aws/install
                aws --version

                #install-eksctl
                curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"| tar xz -C /tmp
                sudo mv /tmp/eksctl /usr/local/bin

                #install-kubectl
                curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
                chmod +x kubectl
                sudo mv ./kubectl /usr/local/bin/kubectl 
                EOF

  tags = {
    Name = "web-server"
  }
}