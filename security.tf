resource "aws_security_group" "sg_for_lb" {
  name   = "${terraform.workspace}_sg_for_lb"
  vpc_id = aws_vpc.vpc_main.id
  ingress {
    description = "Allow HTTP from Internet"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP from Internet"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "To send response back"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_for_ec2" {
  name   = "${terraform.workspace}_sg_for_ec2"
  vpc_id = aws_vpc.vpc_main.id
  ingress {
    description     = "Allow HTTP from Internet"
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.sg_for_lb.id]
  }

  egress {
    description = "To send response back"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}