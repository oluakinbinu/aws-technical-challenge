output "eip" {
  value = aws_eip.eip.id
}
output "nat" {
    value = aws_nat_gateway.nat.id
}