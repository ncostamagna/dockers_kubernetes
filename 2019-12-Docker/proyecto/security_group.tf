resource "aws_security_group" "route_allow_http_ssh" {
    name = "route53_allow_ping_shh_apache"
    vpc_id = "${aws_vpc.main1.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #Visible para todo el mundo
    }

    ingress {
        from_port = 8000
        to_port = 9100
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #Visible para todo el mundo
    }

    ingress {
        from_port = 3000
        to_port = 4000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    # puerto 5000 para probar el ejemplo de registry
    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}