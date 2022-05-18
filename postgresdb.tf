resource "aws_db_subnet_group" "db-group" {
  name       = "db-group"
  subnet_ids = ["${aws_subnet.dbsubnet[0].id}", "${aws_subnet.dbsubnet[1].id}"]

  tags = {
    Name = "db-group"
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
  db_subnet_group_name = aws_db_subnet_group.db-group.name
  vpc_security_group_ids = [ "${aws_security_group.db-sg.id}" ]
  availability_zone = var.azs[0]
  tags = {
    Name = "postgress-db"
  }

}



