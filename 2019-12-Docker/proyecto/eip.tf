resource "aws_eip" "one" {
    vpc = true
    tags = {
        Name = "Elastic IP Nahuel Dockers"
    }
}
resource "aws_eip_association" "eip_server1" {
    instance_id = "${aws_instance.nahuel-server1.id}"
    allocation_id = "${aws_eip.one.id}"
}
