provider "aws" {
    region = "${var.region}"
}
resource "aws_vpc" "main1" {
    cidr_block = "${var.vpc_cidr}"
    instance_tenancy = "default"
    enable_dns_hostnames = "true"

    tags = {
        Name = "VPC curso Kubernetes - Nahuel"
        Location = "US"
    }
}
resource "aws_subnet" "subnet1" {
    availability_zone = "us-east-2a"
    vpc_id = "${aws_vpc.main1.id}"
    cidr_block = "198.168.10.0/24"

    tags = {
        Name = "Nahuel EKS subnet-1"
    }
}


resource "aws_subnet" "subnet2" {
  vpc_id = "${aws_vpc.main1.id}"
  cidr_block = "198.168.20.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Nahuel subnet2"  
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id = "${aws_vpc.main1.id}"
  cidr_block = "198.168.30.0/24"
  availability_zone = "us-east-2c"

  tags = {
    Name = "Nahuel subnet3"  
  }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main1.id}"

    tags = {
        Name = "VPC Main curso EKS"
    }
}
resource "aws_route_table" "web-public-rt" {
    vpc_id = "${aws_vpc.main1.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags = {
        Name = "Public Subnet RT, curso EKS"
    }
}

/*resource "aws_route_table" "web-private-rt" {
    vpc_id = "${aws_vpc.main1.id}"

    route {
        cidr_block = "0.0.0.0/0"
    }

    tags = {
        Name = "Nahuel TF"
    }
}*/

resource "aws_route_table_association" "public-subnet1" {
    subnet_id = "${aws_subnet.subnet1.id}"
    route_table_id = "${aws_route_table.web-public-rt.id}"
}
resource "aws_route_table_association" "table_subnet2" {
  subnet_id = "${aws_subnet.subnet2.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}
/*resource "aws_route_table_association" "table_subnet3" {
  subnet_id = "${aws_subnet.subnet3.id}"
  route_table_id = "${aws_route_table.web-private-rt.id}"
}*/
