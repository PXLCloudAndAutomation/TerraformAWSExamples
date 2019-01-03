#!/usr/bin/env python2

import sys

def copy_file(source, destination):
    out_file = open(destination, "w+")
    for line in open(source).readlines():
        out_file.write(line)

if __name__ == "__main__":
    if len(sys.argv) < 3 or 4 < len(sys.argv):
        exit(-1)

    # Create basic hostfile to start from
    copy_file("./files/hosts_base", "./files/hosts")

    hosts_file   = open("./files/hosts","a+")
    hostname = sys.argv[1]
    domain   = sys.argv[2]
    hosts_file.write("127.0.0.1\t" + hostname + "." + domain + " " + hostname + "\n")

    # Create basic haproxy.cfg to start from
    copy_file("./files/haproxy.cfg_base", "./files/haproxy.cfg")

    # If there are webservers, add them in the hosts and haproxy.cfg files
    if len(sys.argv) == 4:
        haproxy_file = open("./files/haproxy.cfg","a+")

        ips      = sys.argv[3].split(":")
        number = 1
        for ip in ips:
            hosts_file.write(ip + "\twebserver" + str(number) + "\n")
            haproxy_file.write("    server webserver" + str(number) + " " + ip + ":80 check\n")
            number = number + 1
