resource "aws_security_group" "internal-sg" {
  vpc_id = data.aws_vpc.selected.id
  name = "kulearn-dev-internal-sg"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags = {
    Name = "kulearn-dev-internal-sg"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}