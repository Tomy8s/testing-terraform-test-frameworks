resource "aws_instance" "test-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.test-subnet.id

  tags = {
    Name  = "testing-terraform-test-frameworks"
    onwer = "TomY8s"
  }
}

resource "aws_vpc" "test-vpc" {
  cidr_block = "192.168.254.128/25"

  tags = {
    Name  = "testing-terraform-test-frameworks"
    owner = "TomY8s"
  }
}

resource "aws_subnet" "test-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "192.168.254.240/28"

  tags = {
    Name  = "testing-terraform-test-frameworks"
    owner = "TomY8s"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}