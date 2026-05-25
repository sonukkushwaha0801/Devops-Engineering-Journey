# =========================
# Security Group
# =========================

resource "aws_security_group" "frontend_sg" {
  name = "terraform-provisioner-sg"

  description = "Allow SSH and HTTP Access"

  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"

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

  tags = {
    Name      = "terraform-provisioner-sg"
    ManagedBy = "terraform"
  }
}

# =========================
# EC2 Instance
# =========================

resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [
    aws_security_group.frontend_sg.id
  ]

  tags = {
    Name        = var.instance_name
    Environment = "practice"
    ManagedBy   = "terraform"
  }
  # =========================
  # Common SSH Connection
  # =========================

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  # =========================
  # Upload update-system.sh
  # =========================

  provisioner "file" {
    source      = "scripts/update-system.sh"
    destination = "/tmp/update-system.sh"
  }

  # =========================
  # Upload install-nginx.sh
  # =========================

  provisioner "file" {
    source      = "scripts/install-nginx.sh"
    destination = "/tmp/install-nginx.sh"
  }

  # =========================
  # Upload install-python.sh
  # =========================

  provisioner "file" {
    source      = "scripts/install-python.sh"
    destination = "/tmp/install-python.sh"
  }

  # =========================
  # Remote Exec Provisioner
  # =========================

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/update-system.sh",
      "chmod +x /tmp/install-nginx.sh",
      "chmod +x /tmp/install-python.sh",

      "sudo /tmp/update-system.sh",
      "sudo /tmp/install-nginx.sh",
      "sudo /tmp/install-python.sh"
    ]
  }

  # =========================
  # Local Exec Provisioner
  # =========================

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > public_ip.txt"
  }
}
