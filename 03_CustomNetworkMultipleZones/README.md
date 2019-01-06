# Example `03_CustomNetworkMultipleZones`
This code show how to create a custom network in multiple availability zones by creating two instances in different subnets.

## Important subnet information
From [AWS Documentation » Amazon VPC » User Guide » VPCs and Subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html):

> The first four IP addresses and the last IP address in each subnet CIDR block are not available for you to use, and cannot be assigned to an instance. For example, in a subnet with CIDR block 10.0.0.0/24, the following five IP addresses are reserved:
> 
> 10.0.0.0: Network address.
> 
> 10.0.0.1: Reserved by AWS for the VPC router.
> 
> 10.0.0.2: Reserved by AWS. The IP address of the DNS server is always the base of the VPC network range plus two; however, we also reserve the base of each subnet range plus two. For VPCs with multiple CIDR blocks, the IP address of the DNS server is located in the primary CIDR. For more information, see Amazon DNS Server.
> 
> 10.0.0.3: Reserved by AWS for future use.
> 
> 10.0.0.255: Network broadcast address. We do not support broadcast in a VPC, therefore we reserve this address.



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

# 2 Connecting to the instances
The Terraform script will print the complete ssh commands to access the two instances.

An example:

```bash
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

server_one_ssh_command = ssh -i ./key/id_rsa ec2-user@54.161.204.152
server_two_ssh_command = ssh -i ./key/id_rsa ec2-user@3.81.109.238
```
