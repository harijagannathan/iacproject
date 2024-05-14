resource "aws_lb" "custom_locustom_lbadbalancer" {
  name               = "${terraform.workspace}-lb-for-webserver"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_for_lb.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  depends_on         = [aws_internet_gateway.custom_internet_gateway]
}

resource "aws_lb_target_group" "custom_lb_targetgroup" {
  name     = "${terraform.workspace}-custom-lb-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_main.id
}

resource "aws_lb_listener" "custom_lb_lister" {
  load_balancer_arn = aws_lb.custom_locustom_lbadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.custom_lb_targetgroup.arn
  }
}