# Terraform AWS Examples 
A collection of Terraform examples using the AWS provider and other elements to demonstrate different concepts.

These examples also contain a few exercises.
**Commit all the answers to your personal Cloud & Automation repository, acquired during the first lesson.**

## Prerequisites
There are a few prerequisites for these examples. The main prerequisite is a UNIX-like machine with Terraform installed. The others necessary  elements are: Python3, AWS CLI, `wget`, and `psycopg2-binary`. The first two (Terraform and Python3) should be already installed and will be skipped in this `README.md`.

### A. AWS CLI
This is the AWS Command Line Interface. Super handy to quickly interact with Amazon Web Services. To install use `pip`:

```bash
$ pip install awscli --upgrade --user
```

### B. `wget`
GNU Wget is a computer program that retrieves content from web servers. On most distributions and on MacOS, `wget` should be installed by default. If not, execute:

On a DEB-based system:

```bash
$ sudo apt install wget
```

On a RPM-bases system:

```bash
$ sudo yum install -y wget
```

On MacOS (using [Homebrew](https://brew.sh/)):

```bash
$ brew install wget
```

### C. `psycopg2-binary` (For example `07_RelationalDatabaseService`)
Psycopg is the most popular PostgreSQL database adapter for the Python programming language. It's used in example `07_RelationalDatabaseService` to test if the DB is up and running. Use `pip` to install this dependency:

```bash
 $ pip install psycopg2-binary
```


## Before running ANY example
AWS access is absolutely necessary. Test this **before** running any of the examples. **If stops working after a while, the session will probably be expired.** 

Terraform will find the credentials in `~/.aws/credentials`, just like AWS CLI does. Copy and paste the AWS credentials from the website into `~/.aws/credentials`. The AWS CLI command can be used to quickly check the correctness of the credentials. For example, execute a list of S3 by typing the following command:

```bash
$ aws s3 ls
$
```
A clean execution, like the example above, confirms the correctness. Otherwise the output might look like:

```bash
$ aws s3 ls

An error occurred (ExpiredToken) when calling the ListBuckets operation: The provided token has expired.
```

If the above occurs, refresh the credentials and check again by executing an AWS CLI commando.


## Execute an example
Before running an example, read its `README.md` (if provided). Multiple examples need one or more extra commands.

Each subdirectory, listed below in The examples, contains a complete Terraform example, including (when needed) a `terraform.tfvars` file. In general, an example only needs a few steps to get up and running. Execute the commands inside the directory of the example.

```bash
    $ terraform init
    $ terraform plan
    $ terraform apply
```

## The examples and exercise.
This gives a short overview of all the examples.

### `01_LatestAMI`
This example searches for the latest Ubuntu 18.04 AMD64 Server Amazon Machine Image and creates an instance using the result. It also contains a few questions.

### `02_SingleServer`
A single instance with SSH access will be created via this example.

### `03_CustomNetworkMultipleZones`
This code show how to create a custom network in multiple availability zones by creating two instances in different subnets.

### `04_ModuleExample`
Modules are the key ingredient to create reusable components. This Terraform example contains a network module.

### `05_HAProxy`
This exmaple creates multiple webservers behind a HAProxy.

### `06_ElasticLoadBalancing`
> "Elastic Load Balancing automatically distributes incoming application traffic across multiple targets, such as Amazon EC2 instances, containers, IP addresses, and Lambda functions. It can handle the varying load of your application traffic in a single Availability Zone or across multiple Availability Zones." - [source](https://aws.amazon.com/elasticloadbalancing)

### `07_RelationalDatabaseService`
This example creates an Amazon Relational Database Service.
 
> "Amazon Relational Database Service (Amazon RDS) makes it easy to set up, operate, and scale a relational database in the cloud. It provides cost-efficient and resizable capacity while automating time-consuming administration tasks such as hardware provisioning, database setup, patching and backups. It frees you to focus on your applications so you can give them the fast performance, high availability, security and compatibility they need.
>
> Amazon RDS is available on several database instance types - optimized for memory, performance or I/O - and provides you with six familiar database engines to choose from, including Amazon Aurora, PostgreSQL, MySQL, MariaDB, Oracle Database, and SQL Server. You can use the AWS Database Migration Service to easily migrate or replicate your existing databases to Amazon RDS." - [source](https://aws.amazon.com/rds/)

### `08_LambdaAndRESTGateway`
This example creates an Amazon Lambda function with an Amazon API Gateway.

> "AWS Lambda lets you run code without provisioning or managing servers. You pay only for the compute time you consume - there is no charge when your code is not running. " - [source](https://aws.amazon.com/lambda/)
