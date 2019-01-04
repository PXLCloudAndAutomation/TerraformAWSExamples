# Example `02_SingleServer`
A single instance with SSH access will be created via this example. It will use the default VPC. 

**Remark:**
One important Terraform quirk, to access the default VPC a `resource` should be used. A `data` block will not work with the default VPC.


# 1 Before running the script
Do not forget to run the `create_ssh_keys_local.sh` script before running `terraform` `plan` or `apply`. It will create a `key` directory containing  the private and public key to access the instance.

The ouput will look like the output below:

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

# 2 Connecting to the instance
The Terraform script will print the public IP of the instance. Use the `ssh` command with the private key to access the server. The username depends on the used AMI. There are two AMI ids in de code, one for Ubuntu and one for RHEL. The usernames are provided in the comments.

An example:

```bash
$ ssh -i ./key/id_rsa ec2-user@34.207.94.182
The authenticity of host '34.207.94.182 (34.207.94.182)' can't be established.
ECDSA key fingerprint is SHA256:hhoncIyfLe1qg1eJuywokG43KllmJWP90+blMi/DxJA.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '34.207.94.182' (ECDSA) to the list of known hosts.
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
[ec2-user@ip-172-31-83-54 ~]$
```

## Known connection issue:
It's possible and common, especially  right after creating the instance, the command returns a `Connection refused` error.

```bash
$ ssh -i ./key/id_rsa ec2-user@34.207.94.182
ssh: connect to host 34.207.94.182 port 22: Connection refused
$
```
**Reason:** the instance isn't ready for incomming SSH requests. **Solution:** Just wait a little bit, the instance should be ready in less than one or two minutes.