resource "aws_db_subnet_group" "dbgroup" {
  name       = "dbgroup"
  subnet_ids = ["${aws_subnet.subnets[2].id}", "${aws_subnet.subnets[3].id}"]

  tags = {
    Name = "dbgroup"
  }
}


resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "postgres"   
  engine_version       = "13.4"
  instance_class       = "db.t3.medium"
  name                 = "mydb"
  username             = "dbadmin1"
  password             = "postgress"
  db_subnet_group_name = aws_db_subnet_group.dbgroup.name
  vpc_security_group_ids = [ "${aws_security_group.db-sg.id}" ]
  availability_zone = var.azs[0]
  tags = {
    Name = "postgress-db"
  }

}



