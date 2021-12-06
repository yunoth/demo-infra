resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "alb-sg"
  }
}
resource "aws_security_group" "instance-sg" {
  name        = "instance-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "instance-sg"
  }
}
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "db-sg"
  }
}
resource "aws_security_group_rule" "alb-rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "https"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-sg.id
}
resource "aws_security_group_rule" "instance-rule" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "http"
  source_security_group_id = aws_security_group.alb-sg.id
  security_group_id = aws_security_group.instance-sg.id
}
resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.example.cidr_block]
  ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = aws_security_group.instance-sg.id
  security_group_id = aws_security_group.db-sg.id
}