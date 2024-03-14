provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region = "eu-west-2"
}

resource "aws_security_group" "k8s_security_group" {
  name        = "md_k8s_security_group"
  description = "allow all internal traffic, ssh, http from anywhere"
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = "true"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9411
    to_port     = 9411
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30001
    to_port     = 30001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30002
    to_port     = 30002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
   from_port   = 31601
   to_port     = 31601
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

resource "aws_instance" "socks_shop_master" {
  instance_type   = "t2.micro"
  ami             = lookup(var.aws_amis, var.aws_region)
  key_name        = var.key_name
  security_groups = ["sg-00bbfaae47f997018"]
   
  tags = {
    Name = "socks_shop_master"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "capstone.pem"
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "deploy/kubernetes/manifests"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "sudo echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee --append /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni"
    ]
  }
}

resource "aws_instance" "socks_shop_node" {
  instance_type   = "t2.micro"
  count           = var.node_count
  ami             = lookup(var.aws_amis, var.aws_region)
  key_name        = var.key_name
  security_groups = ["sg-00bbfaae47f997018"]
  
tags = {
    Name = "socks_shop_node"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "capstone.pem"
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "sudo echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee --append /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni",
      "sudo sysctl -w vm.max_map_count=262144"
    ]
  }
}

resource "aws_elb" "socks-shop" {
  depends_on         = [aws_instance.socks_shop_node]
  name               = "socks-shop"
  instances          = aws_instance.socks_shop_node.*.id
  availability_zones = data.aws_availability_zones.available.names
  security_groups    = ["sg-00bbfaae47f997018"] 
  
  listener {
    lb_port           = 80
    instance_port     = 30001
    lb_protocol       = "http"
    instance_protocol = "http"
  }

  listener {
    lb_port           = 9411
    instance_port     = 30002
    lb_protocol       = "http"
    instance_protocol = "http"
  }
}

resource "aws_eks_cluster" "socks-shop-cluster" {
  name     = "socks-shop-cluster"
  version  = "1.21"
  role_arn = "arn:aws:iam::585594595550:user/chayablue"
  
  vpc_config {
    subnet_ids      = ["subnet-0110975891fec9666", "subnet-0483f19d3337a0d0f"]  
    security_group_ids = ["sg-00bbfaae47f997018"]  
  }
}
