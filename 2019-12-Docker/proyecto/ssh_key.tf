resource "aws_key_pair" "key-class-1" {
    key_name = "nahuel_class_key1"
    public_key = "${file("class_key.pem.pub")}"
}