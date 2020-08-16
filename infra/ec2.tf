resource "aws_instance" "nahuel-server1" {
    #Ubuntu
    ami = "ami-0d5d9d301c853a04a"
    instance_type = "t2.small"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.route_allow_http_ssh.id}"]
    subnet_id = "${aws_subnet.subnet1.id}"
    private_ip = "198.168.10.11"
    key_name = "${aws_key_pair.key-class-1.id}"

    depends_on = ["aws_internet_gateway.gw"]

    user_data = "${file("userdata.sh")}"
    tags = {
        Name = "Nahuel EKS"
        Owner = "Curso Kubernetes"
        Env = "dev"
    }
}