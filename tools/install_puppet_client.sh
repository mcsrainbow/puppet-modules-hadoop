#!/bin/bash
#File Managed by Puppet

function check_root()
{
    if [ $EUID -ne 0 ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi
}

function configure_selinux()
{
    setenforce 0
    sed -i s/'SELINUX=enforcing'/'SELINUX=disabled'/g /etc/selinux/config 
}

function stop_iptables()
{
    /etc/init.d/iptables stop
}

function configure_repo()
{
    if [ ! -f /etc/yum.repos.d/puppet.repo ]; then
        cat >> /etc/yum.repos.d/puppet.repo << EOF
[puppetlabs]
name=Puppet Labs Packages
baseurl=http://yum.puppetlabs.com/el/6/products/$basearch/
enabled=1
gpgcheck=0
gpgkey=http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
EOF
    fi
}

function install_puppet()
{
    rpm -qa | grep epel-release-6-8
    if [ $? -ne 0 ]; then
        yum -y erase puppet
        rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
        yum -y install puppet 
    fi
}

function configure_puppet()
{
    grep puppetmaster /etc/puppet/puppet.conf 
    if [ $? -ne 0 ]; then
        echo "server = puppetmaster " >> /etc/puppet/puppet.conf 
    fi
}

function configure_hosts()
{
    grep puppetmaster /etc/hosts 
    if [ $? -ne 0 ]; then
        echo "10.197.29.251 puppetmaster" >> /etc/hosts 
    fi
}

function run_puppet()
{
    puppet agent --no-daemonize --onetime --debug
}

check_root
configure_selinux
stop_iptables
configure_repo
install_puppet
configure_puppet
configure_hosts
run_puppet
