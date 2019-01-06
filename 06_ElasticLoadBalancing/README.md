# Example `06_ElasticLoadBalancing`
> "Elastic Load Balancing automatically distributes incoming application traffic across multiple targets, such as Amazon EC2 instances, containers, IP addresses, and Lambda functions. It can handle the varying load of your application traffic in a single Availability Zone or across multiple Availability Zones." - [source](https://aws.amazon.com/elasticloadbalancing)

# 1 Before running the script
Do not forget to run the `create_ssh_keys_local.sh` script before running `terraform` `plan` or `apply`. It will create a `key` directory containing  the private and public key to access the instances.

The ouput will look like the listing below:

```bash
$ ./create_ssh_keys_local.sh
Generating public/private rsa key pair.
Your identification has been saved in ./key/id_rsa.
Your public key has been saved in ./key/id_rsa.pub.
The key fingerprint is:
SHA256:0ee7EmpJ5mUC4QXaMs+2aNsOSOAuU3joFCq7S44lNHg user
The key's randomart image is:
+---[RSA 4096]----+
|      ..         |
|     o. ..       |
|..  +..o. . .    |
|++.  =o  . o     |
|*=E   +.S   .    |
|**.. o .+ +  .   |
|=+o + .+ * ..    |
|== . +  = .  .   |
|+o  ..o.   ..    |
+----[SHA256]-----+
$
```
**After creating the key, Terraform can be executed.**

# 2 Testing the infrastructure
The Terraform script will also print a testing command.

An example:

```bash
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

address = WEB-ELB-829383435.us-east-1.elb.amazonaws.com
test_command = wget WEB-ELB-829383435.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
web_private_ips = [
    10.0.0.8,
    10.0.0.114
]
web_public_ips = [
    18.207.202.65,
    35.175.150.212
]
```

Use this to test:

```bash
$ wget WEB-ELB-829383435.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.114</h1>
$ wget WEB-ELB-829383435.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.8</h1>
$ wget WEB-ELB-829383435.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.8</h1>
$ wget WEB-ELB-829383435.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.114</h1>
$ wget WEB-ELB-829383435.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.8</h1>
$ wget WEB-ELB-829383435.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.114</h1>
```

Notice the different IPs (10.0.0.8 and 10.0.0.114).

## Known issue
It's possible and common, especially right after creating the infrastructure, the test command returns an error.

```bash
$ wget WEB-ELB-829383435.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
cat: index.html: No such file or directory
$
```
**Reason:** the load balancer isn't ready for incomming requests. **Solution:** Just wait a little bit, the load balancer should be ready in less than one or two minutes.