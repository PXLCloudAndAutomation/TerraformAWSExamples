#!/bin/bash

if [ ! -d ./key ] ; then
    mkdir ./key
fi

if [ ! -f ./key/id_rsa ] || [ ! -f ./key/id_rsa.pub ] ; then
    ssh-keygen -t rsa -b 4096 -C 'user' -N '' -f ./key/id_rsa
fi
