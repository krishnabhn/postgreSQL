resource "aws_vpc" "dev" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"
  tags = {
    Name = "Dev"
  }
}

resource "aws_internet_gateway" "demogateway" {
  vpc_id = "${aws_vpc.dev.id}"
  tags = {
    Name = "Demo igw"
  }
}


#resource "aws_subnet" "demosubnet" {
  #count= length(var.pubsub)  
 # vpc_id                  = "${aws_vpc.dev.id}"
  #cidr_block             = var.pubsub[count.index]
#  map_public_ip_on_launch = true
  #availability_zone = var.azs[count.index]
 # tags = {
  #  Name = "subnets"
 # }
#}


resource "aws_subnet" "dbsubnet" {
  count= length(var.pvtsub)  
  vpc_id                  = "${aws_vpc.dev.id}"
  cidr_block             = var.pvtsub[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.azs[count.index]
  tags = {
    Name = "subnets"
  }
}


# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "nat-gateway-eip" {
  vpc = true
}

# Creating a NAT Gateway!
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id = aws_subnet.demosubnet[1].id
  tags = {
    Name = "Nat-Gateway"
  }
}


#Creating Route Table
resource "aws_route_table" "publicroute" {
  vpc_id = "${aws_vpc.dev.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.demogateway.id}"
    }
  tags = {
        Name = "Route to internet"
  }
}

resource "aws_route_table" "privateroute" {
  vpc_id = "${aws_vpc.dev.id}"
   route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "Private route"
  }
}


resource "aws_route_table_association" "rt1" {
   subnet_id = "${aws_subnet.subnets[0].id}"
   route_table_id = "${aws_route_table.publicroute.id}"
}
resource "aws_route_table_association" "rt2" {
   subnet_id = "${aws_subnet.subnets[1].id}"
   route_table_id = "${aws_route_table.publicroute.id}"
}

resource "aws_route_table_association" "rt3" {
   subnet_id = "${aws_subnet.subnets[2].id}"
   route_table_id = "${aws_route_table.privateroute.id}"
}

resource "aws_route_table_association" "rt4" {
   subnet_id = "${aws_subnet.subnets[3].id}"
   route_table_id = "${aws_route_table.privateroute.id}"
}   
