#!/bin/bash

yum update -y
yum install epel-release -y
yum install ansible glibc-common policycoreutils -y 
useradd fusioniam 
systemctl disable kdump 
yum clean all

