#!/bin/bash

yum update

echo "kernel parameters ..."
echo "fs.file-max = 6815744" >>/etc/sysctl.conf
echo "vm.swappiness = 1" >>/etc/sysctl.conf

# disable selinux
setenforce 0
# disable firewall
systemctl disable firewalld
# set ulimits
echo "* soft nproc 65535" >>/etc/security/limits.conf
echo "* hard nproc 65535" >>/etc/security/limits.conf
echo "* soft nofile 65535" >>/etc/security/limits.conf
echo "* hard nofile 65535" >>/etc/security/limits.conf

# generate ssh public
ssh -keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >>~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# install java 1.8
yum install java-1.8.0-openjdk -y
echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" profile.d/java.sh >/etc/
source /etc/profile.d/java.sh

# install wget and download hadoop
yum install wget -y
cd root
wget https://dlcdn.apache.org/hadoop/common/stable/hadoop-3.3.3.tar.gz

mkdir –p /opt/hadoop
cd /opt/hadoop
tar -xvzf /root/hadoop-3.3.3.tar.gz

echo "export HADOOP_HOME=/opt/hadoop/hadoop-3.3.3" profile.d/hadoop.sh >/etc/
source /etc/profile.d/hadoop.sh

mkdir -p /var/log/hadoop/logs

echo "hadoop-env.sh ..."
echo 'export HADOOP_LOG_DIR=/var/log/hadoop/logs 
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh





#groupadd hadoop
# useradd –g hadoop hadoopuser



# install additional apps
yum install vim-enhanced -y
yum install net-tools -y

