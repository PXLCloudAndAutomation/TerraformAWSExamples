# Example `05_HAProxy`
This exmaple creates multiple webservers behind a HAProxy.

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
The Terraform script will print a testing command.

An example:

```bash
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

test_command = wget 3.83.162.120 2>/dev/null ; cat index.html | grep served ; rm index.html
```

Use this to test:

```bash
$ wget 3.83.162.120 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.191</h1>
$ wget 3.83.162.120 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.22</h1>
$
```

Notice the different IPs (10.0.0.191 and 10.0.0.22).