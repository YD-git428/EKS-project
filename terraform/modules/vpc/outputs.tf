output "vpcid" {
  value = aws_vpc.eks_vpc.id
}

output "igw_arn" {
  value = aws_internet_gateway.eks-igw.id
}

output "subnet1_id" {
  value = aws_subnet.eks_public_subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.eks_public_subnet2.id
}

output "subnet3_id" {
  value = aws_subnet.eks_public_subnet3.id
}

output "subnet4_id" {
  value = aws_subnet.eks_private_subnet1.id
}

output "subnet5_id" {
  value = aws_subnet.eks_private_subnet2.id
}

output "subnet6_id" {
  value = aws_subnet.eks_private_subnet3.id
}

output "route_tableid" {
  value = aws_route_table.eks_route_table_pub.id
}

