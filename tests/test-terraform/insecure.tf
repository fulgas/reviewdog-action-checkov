# This file intentionally contains security issues for testing

resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-test-bucket-12345"

  # Security Issue: ACL should not be public
  acl = "public-read"
}

resource "aws_security_group" "test_sg" {
  name        = "test-security-group"
  description = "Test security group with issues"

  # Security Issue: Port 22 open to world
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Security Issue: All ports open
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "test_db" {
  identifier           = "test-database"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "admin"
  password             = "password123"  # Security Issue: Hardcoded password

  # Security Issue: Not encrypted
  storage_encrypted = false

  # Security Issue: Publicly accessible
  publicly_accessible = true

  # Security Issue: Deletion protection disabled
  deletion_protection = false

  skip_final_snapshot = true
}