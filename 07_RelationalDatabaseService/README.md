# Example `07_RelationalDatabaseService`
This example creates an Amazon Relational Database Service.
 
> "Amazon Relational Database Service (Amazon RDS) makes it easy to set up, operate, and scale a relational database in the cloud. It provides cost-efficient and resizable capacity while automating time-consuming administration tasks such as hardware provisioning, database setup, patching and backups. It frees you to focus on your applications so you can give them the fast performance, high availability, security and compatibility they need.
>
> Amazon RDS is available on several database instance types - optimized for memory, performance or I/O - and provides you with six familiar database engines to choose from, including Amazon Aurora, PostgreSQL, MySQL, MariaDB, Oracle Database, and SQL Server. You can use the AWS Database Migration Service to easily migrate or replicate your existing databases to Amazon RDS." - [source](https://aws.amazon.com/rds/)

# Testing the infrastructure
The Terraform script will also print a testing command.

An example:

```bash
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

db_endpoint = mydb-rds.caouy9vnbpdj.us-east-1.rds.amazonaws.com:5432
test_command = ./test_db.py mydb-rds.caouy9vnbpdj.us-east-1.rds.amazonaws.com mydb mydbuser QjgfGquc5elBcRtDyOwBQW3PdM9TKrOlle
```

Use this to test:

```bash
$ ./test_db.py mydb-rds.caouy9vnbpdj.us-east-1.rds.amazonaws.com mydb mydbuser QjgfGquc5elBcRtDyOwBQW3PdM9TKrOlle
CONNECTED!
```