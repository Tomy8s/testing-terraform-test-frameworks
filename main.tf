resource "aws_instance" "test-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  associate_public_ip_address = true
  subnet_id     = aws_subnet.test-subnet.id

  tags = var.tags
  security_groups = [aws_security_group.instance.id]

  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
echo "Hello, World!" > /var/www/html/index.html
sudo systemctl start apache2
EOF
}

resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.test-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = var.tags
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.test-vpc.id

  route = [
    {
      cidr_block  = "0.0.0.0/0"
      gateway_id  = aws_internet_gateway.gw.id
      egress_only_gateway_id = ""
      ipv6_cidr_block = ""
      instance_id = ""
      local_gateway_id = ""
      nat_gateway_id = ""
      network_interface_id = ""
      transit_gateway_id = ""
      vpc_peering_connection_id = ""
      vpc_endpoint_id = ""
      carrier_gateway_id = ""
      destination_prefix_list_id = ""
    }
  ]
  tags = var.tags
}

resource "aws_route_table_association" "b" {
  subnet_id = aws_subnet.test-subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_vpc" "test-vpc" {
  cidr_block = "192.168.254.128/25"

  tags = var.tags
}

resource "aws_subnet" "test-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "192.168.254.240/28"

  tags = var.tags
}
