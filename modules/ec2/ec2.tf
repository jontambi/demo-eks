locals {
  ssh_user         = "centos"
  key_name         = "demo"
  private_key_path = "../../credentials/demo.pem"
}

# Create AWS Instance

resource "aws_instance" "bastion" {
  count = 1

  #    ami                         = data.aws_ami.k8s_ami.id
  ami                         = "ami-0affd4508a5d2481b"
  availability_zone           = element(var.azs, count.index)
  instance_type               = "t2.micro"
  key_name                    = local.key_name
  vpc_security_group_ids      = [var.master_security_group]
  subnet_id                   = element(var.public_subnet_id, count.index)
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-${var.vpc_name}-bastion-${count.index + 1}"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      #host        = var.aws_eip
      host = aws_instance.bastion[count.index].public_ip
    }
  }
  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook -i ${aws_instance.bastion[count.index].public_ip}, --private-key ${local.private_key_path} ../ansible/update-system.yaml
    EOT
  }

}

/***
# Create AWS Instance Worker

resource "aws_instance" "worker_server" {
    count                       = 1

#    ami                         = data.aws_ami.k8s_ami.id
    ami                         = ami-0affd4508a5d2481b 
    availability_zone           = element(var.azs, count.index)
    instance_type               = "t2.micro"
    key_name                    = local.key_name 
    vpc_security_group_ids      = [var.master_security_group]
    subnet_id                   = element(var.public_subnet_id, count.index)
#    associate_public_ip_address = true

    tags = {
        Name = "${var.environment}-${var.vpc_name}-worker-${count.index + 1}"
    }

}

# AWS Select latest AMI
data "aws_ami" "k8s_ami" {
    owners = ["179966331834"]
    most_recent = true

    filter {
        name = "state"
        values = ["available"]
    }

    filter {
        name = "tag:Name"
        values = ["Image_base_Centos7"]
    }
}
***/
