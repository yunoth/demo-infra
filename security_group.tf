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
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-sg.id
}
resource "aws_security_group_rule" "instance-rule" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = aws_security_group.alb-sg.id
  security_group_id = aws_security_group.instance-sg.id
}
resource "aws_security_group_rule" "db-rule" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = aws_security_group.instance-sg.id
  security_group_id = aws_security_group.db-sg.id
}