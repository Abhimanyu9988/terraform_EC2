provider "aws" {
  region              = "us-east-1"
  profile             = "abhipersonalaws"
  shared_config_files = ["/Users/abhibaj/.aws/config"]
}


resource "aws_instance" "aws_instance_for_rds" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.small"
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "aws_instance_for_rds"
    Owner = "AbhiBajaj"
  }
  key_name = "aws_key"


####COMMENT: For making provisioner that will copy script inside the EC2
####REFERRENCE: https://jhooq.com/terraform-ssh-into-aws-ec2/

 provisioner "file" {
  source="/Users/abhibaj/terraform/Personal/modules/EC2/script.sh"
  destination="/tmp/script.sh"
}


 provisioner "remote-exec" {
  inline=[
  "sudo chmod +x /tmp/script.sh",
  "sudo /tmp/script.sh"
  ]
}

 connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/Users/abhibaj/terraform/Personal/modules/EC2/aws_key")
      timeout     = "4m"
   }

}


resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}


resource "aws_key_pair" "aws_key_for_rds_ec2" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3tOQpDZ0b0jnrqpxQFhzXc8z/lPCUnkeBhXDCm0vG9LBhYdKi4/9yUKXUZURzojffqPTmsDVl2BhutQpZGoRQHPWbM22QaA3Xa1y/BXScNERh6JyiYsdtbd8FtaJviWrYeKYhI9Gib4+AI9WKkoGBsDmjZqptqPlFHWWwoLfcXQiwDcj7s3fhcNrIwm50Gwx/N28YtrrYe9z2ua+lX1VYUl572+BzZPK5bp342LLUirPg2gth+WFt7Ua73AFGbDqFMSnY4EHokn9aDD8cFtryIBb0OGdcdsxSe29XTA5wBvC9ytgVbdHvxUHWp2r8DukXxfZzCb1optl9Nzo7qAiF abhibaj@ABHIBAJ-M-3BER"
}
