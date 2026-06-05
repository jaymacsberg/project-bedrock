resource "aws_security_group" "databases" {
  name        = "project-bedrock-databases"
  description = "Allow database access only from EKS worker nodes"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "project-bedrock-databases"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mysql_from_eks" {
  security_group_id            = aws_security_group.databases.id
  referenced_security_group_id = module.eks.node_security_group_id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "Allow MySQL from EKS nodes"
}

resource "aws_vpc_security_group_ingress_rule" "postgres_from_eks" {
  security_group_id            = aws_security_group.databases.id
  referenced_security_group_id = module.eks.node_security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Allow PostgreSQL from EKS nodes"
}

resource "random_password" "catalog" {
  length  = 24
  special = false
}

resource "random_password" "orders" {
  length  = 24
  special = false
}

resource "aws_db_instance" "catalog" {
  identifier = "project-bedrock-catalog-mysql"

  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = "catalog"
  username = "adminuser"
  password = random_password.catalog.result
  port     = 3306

  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.databases.id]

  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0
  apply_immediately       = true

  tags = {
    Name = "project-bedrock-catalog-mysql"
  }
}

resource "aws_db_instance" "orders" {
  identifier = "project-bedrock-orders-postgres"

  engine         = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = "orders"
  username = "adminuser"
  password = random_password.orders.result
  port     = 5432

  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.databases.id]

  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0
  apply_immediately       = true

  tags = {
    Name = "project-bedrock-orders-postgres"
  }
}

resource "aws_secretsmanager_secret" "catalog" {
  name = "project-bedrock/catalog-db"

  tags = {
    Name = "project-bedrock-catalog-secret"
  }
}

resource "aws_secretsmanager_secret_version" "catalog" {
  secret_id = aws_secretsmanager_secret.catalog.id

  secret_string = jsonencode({
    username = aws_db_instance.catalog.username
    password = random_password.catalog.result
    host     = aws_db_instance.catalog.address
    port     = aws_db_instance.catalog.port
    dbname   = aws_db_instance.catalog.db_name
  })
}

resource "aws_secretsmanager_secret" "orders" {
  name = "project-bedrock/orders-db"

  tags = {
    Name = "project-bedrock-orders-secret"
  }
}

resource "aws_secretsmanager_secret_version" "orders" {
  secret_id = aws_secretsmanager_secret.orders.id

  secret_string = jsonencode({
    username = aws_db_instance.orders.username
    password = random_password.orders.result
    host     = aws_db_instance.orders.address
    port     = aws_db_instance.orders.port
    dbname   = aws_db_instance.orders.db_name
  })
}

resource "aws_dynamodb_table" "carts" {
  name         = "project-bedrock-carts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "customerId"
    type = "S"
  }

  global_secondary_index {
    name            = "idx_global_customerId"
    hash_key        = "customerId"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name = "project-bedrock-carts"
  }
}
