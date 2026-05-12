terraform {
  required_version = "~> 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "lecture-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "lecture-igw" }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "lecture-subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "lecture-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${path.module}/lecture-key.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0600"
}

resource "aws_security_group" "ssh_sg" {
  name   = "allow-ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
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

data "aws_ami" "latest_al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "EC2-S3-Access-Role2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2-S3-Instance-Profile2"
  role = aws_iam_role.ec2_s3_role.name
}

resource "aws_instance" "my_ec2" {
  ami                    = data.aws_ami.latest_al2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  key_name               = aws_key_pair.kp.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  tags                   = { Name = "ec2-db" }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.yml"
  content = yamlencode({
    all = {
      hosts = {
        "${aws_instance.my_ec2.public_ip}" = {
          ansible_user                 = "ec2-user"
          ansible_ssh_private_key_file = "${path.module}/lecture-key.pem"
        }
      }
    }
  })
}

resource "local_file" "ansible_config" {
  filename = "${path.module}/ansible.cfg"
  content  = <<-EOF
        [defaults]
        inventory = ./inventory.yml
        host_key_checking = False
    EOF
}

resource "terraform_data" "wait_for_instance" {
  depends_on = [aws_instance.my_ec2, local_file.ansible_inventory, local_file.ansible_config]
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

# ------- ansible playbook (줄바꿈 오류 수정 버전) ---------
resource "terraform_data" "ansible_run" {
  depends_on = [terraform_data.wait_for_instance]

  provisioner "local-exec" {
    command = "ANSIBLE_SSH_PIPELINING=1 ansible-playbook site.yml -e \"{'new_db_ip': '${aws_instance.my_ec2.public_ip}', 'postgresql_packages': ['postgresql15', 'postgresql15-server', 'postgresql15-contrib'], 'postgresql_daemon': 'postgresql', 'postgresql_bin_path': '/usr/bin', 'postgresql_data_dir': '/var/lib/pgsql/data'}\""
  }
}
