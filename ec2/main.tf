
resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = var.component
  }
}
resource "null_resource" "null" {
  provisioner "remote-exec" {
    connection {
      host = aws_instance.instance.public_ip
      user = "root"
      password = "DevOps321"
    }
    inline = [
    "ansible-pull -i localhost, -U https://github.com/shuja-git/roboshop-ansible-4 roboshop.yml -e role_name=${var.component}"
    ]
  }
}
resource "aws_security_group" "allow_tls" {
  name        = "${var.component}-${var.env}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }

egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
}
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.component}-${var.env}.shujathdevops.online"
  type    = "A"
  ttl     = 300
  records = [aws_instance.instance.private_ip]
}

