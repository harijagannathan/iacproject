resource "aws_launch_template" "webserver_launch_template" {
  name_prefix   = "${terraform.workspace}_webserver_template"
  image_id      = "ami-03238ca76a3266a07"
  instance_type = "t3.micro"
  user_data     = filebase64("./install-apache.sh")

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.private_subnets[0].id
    security_groups             = [aws_security_group.sg_for_ec2.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${terraform.workspace}_webserver"
    }
  }
}

resource "aws_autoscaling_group" "webserver_autoscaling_group" {
  desired_capacity = var.desired_instance_count
  max_size         = var.max_instance_count
  min_size         = var.min_instance_count

  target_group_arns = [aws_lb_target_group.custom_lb_targetgroup.arn]

  vpc_zone_identifier = [for subnet in aws_subnet.private_subnets : subnet.id]

  launch_template {
    id      = aws_launch_template.webserver_launch_template.id
    version = "$Latest"
  }

}