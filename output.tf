output "vpc_main" {
  value = aws_vpc.vpc_main.tags["Name"]
}
output "vpc_cidr" {
  value = aws_vpc.vpc_main.cidr_block
}
output "website_url" {
    value = "${upper(terraform.workspace)} Environment - http://${aws_lb.custom_locustom_lbadbalancer.dns_name}"
}