resource "aws_vpc" "eks_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_tag
  }

  lifecycle {
    prevent_destroy = false
  }

}
resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = var.igw_tag
  }
}

resource "aws_route_table" "eks_route_table_pub" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }

  tags = {
    Name = var.route_tablepub_tag
  }
}

resource "aws_route_table" "eks_route_table_pub_nat1" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat1.id
  }

  tags = {
    Name = var.route_tablepriv_tag
  }
}

resource "aws_route_table" "eks_route_table_pub_nat2" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat2.id
  }

  tags = {
    Name = var.route_tablepriv_tag
  }
}

resource "aws_route_table" "eks_route_table_pub_nat3" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat3.id
  }

  tags = {
    Name = var.route_tablepriv_tag
  }
}

resource "aws_subnet" "eks_public_subnet1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone1


  tags = {
    Name = var.subnet1_tag
  }
}
resource "aws_subnet" "eks_public_subnet2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone2



  tags = {
    Name = var.subnet2_tag
  }
}

resource "aws_subnet" "eks_public_subnet3" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone3



  tags = {
    Name = var.subnet3_tag
  }
}

resource "aws_route_table_association" "subnet-1" {
  subnet_id      = aws_subnet.eks_public_subnet1.id
  route_table_id = aws_route_table.eks_route_table_pub.id
}

resource "aws_route_table_association" "subnet-2" {
  subnet_id      = aws_subnet.eks_public_subnet2.id
  route_table_id = aws_route_table.eks_route_table_pub.id
}

resource "aws_route_table_association" "subnet-3" {
  subnet_id      = aws_subnet.eks_public_subnet3.id
  route_table_id = aws_route_table.eks_route_table_pub.id
}


resource "aws_subnet" "eks_private_subnet1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.availability_zone1


  tags = {
    Name = var.subnet1pub_tag
  }
}
resource "aws_subnet" "eks_private_subnet2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.availability_zone2



  tags = {
    Name = var.subnet2pub_tag
  }
}

resource "aws_subnet" "eks_private_subnet3" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = var.availability_zone3



  tags = {
    Name = var.subnet3pub_tag
  }
}

resource "aws_route_table_association" "subnet-4" {
  subnet_id      = aws_subnet.eks_private_subnet1.id
  route_table_id = aws_route_table.eks_route_table_pub_nat1.id
}

resource "aws_route_table_association" "subnet-5" {
  subnet_id      = aws_subnet.eks_private_subnet2.id
  route_table_id = aws_route_table.eks_route_table_pub_nat2.id
}

resource "aws_route_table_association" "subnet-6" {
  subnet_id      = aws_subnet.eks_private_subnet3.id
  route_table_id = aws_route_table.eks_route_table_pub_nat3.id
}

resource "aws_eip" "nat-eip1" {
  domain = "vpc"
  tags = {
    Name = "eks-nat-eip1"
  }
}

resource "aws_eip" "nat-eip2" {
  domain = "vpc"
  tags = {
    Name = "eks-nat-eip2"
  }
}

resource "aws_eip" "nat-eip3" {
  domain = "vpc"
  tags = {
    Name = "eks-nat-eip3"
  }
}

resource "aws_nat_gateway" "eks_nat1" {
  allocation_id = aws_eip.nat-eip1.id
  subnet_id     = aws_subnet.eks_public_subnet1.id

  tags = {
    Name = "nat-eks1"
  }
  depends_on = [aws_internet_gateway.eks-igw]
}

resource "aws_nat_gateway" "eks_nat2" {
  allocation_id = aws_eip.nat-eip2.id
  subnet_id     = aws_subnet.eks_public_subnet2.id

  tags = {
    Name = "nat-eks2"
  }
  depends_on = [aws_internet_gateway.eks-igw]
}

resource "aws_nat_gateway" "eks_nat3" {
  allocation_id = aws_eip.nat-eip3.id
  subnet_id     = aws_subnet.eks_public_subnet3.id

  tags = {
    Name = "nat-eks3"
  }
  depends_on = [aws_internet_gateway.eks-igw]
}






