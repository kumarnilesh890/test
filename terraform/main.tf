resource "aws_instance" "jenkins_ec2" {
  ami           = "ami-0ff5003538b60d5ec" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"

  tags = {
    Name = "jenkins-created-ec2"
  }
}
