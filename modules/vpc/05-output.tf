output "public-eu-west-1a" {
  value = aws_subnet.public-eu-west-1a.id
  
}
output "public-eu-west-1b" {
  value = aws_subnet.public-eu-west-1b.id
}
output "private-eu-west-1a" {
  value = aws_subnet.private-eu-west-1a.id
}
output "private-eu-west-1b" {
  value = aws_subnet.private-eu-west-1b.id
}
output "vpc"{
  value = aws_vpc.vpc.id
}
output "igw"{
  value = aws_internet_gateway.igw.id
}