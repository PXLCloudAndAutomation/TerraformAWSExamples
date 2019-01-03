#!/usr/bin/env python3
import sys
import psycopg2

if __name__ == "__main__":
    if len(sys.argv) == 5:
        conn_string = "host='" + sys.argv[1] + "' dbname='" + sys.argv[2] + "' user='" + sys.argv[3] + "' password='" + sys.argv[4] + "'"
        conn = psycopg2.connect(conn_string)

        cursor = conn.cursor()
        print("CONNECTED!")

    else:
        print("Usage: " + sys.argv[0] + " host dbname user password")
        exit(-1)

