resource "aws_security_group" "sg" {
  vpc_id      = aws_vpc.aws_vpc.id
  name        = "SSH"
  description = "Allow SSH Traffic"

  tags = {
    Name = "SSH Security Group"
  }
  ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    #cidr_blocks = ["${format(jsondecode(data.http.ipinfo.body).ip)}/32"]
    cidr_blocks = ["${chomp(data.http.icanhazip.response_body)}/32"]
  }
  ingress {

    from_port = -1
    to_port   = -1
    protocol  = "icmp"

    cidr_blocks = [var.gcp_vpc_cidr, var.azure_vpc_cidr]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}