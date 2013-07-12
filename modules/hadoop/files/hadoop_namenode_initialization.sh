#!/bin/bash
#File Managed by Puppet

function check_root()
{
    if [ $EUID -ne 0 ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi
}

function format_namenode()
{
    check_root

    CONF="/etc/hadoop/conf/hdfs-site.xml"
    DATA_DIR=`grep -A 2 "dfs.data.dir" $CONF | grep -oP '(?<=<value>).*(?=</value>)'`
    
    if [ ! -d $DATA_DIR ]; then
        echo "The dfs.data.dir: $DATA_DIR dose not exist."
        exit 0
    fi

    if [ -f $DATA_DIR/current/VERSION ]; then
        echo "The namenode has already been formatted."
        exit 0
    else 
        echo "Format the HDFS on Namenode"
        sudo -u hdfs hadoop namenode -format
        
        echo "Start the namenode service"
        sudo /etc/init.d/hadoop-0.20-namenode start 
    fi
}

function create_dirs()
{
    echo "Create the directories for Map-Reduce"
    sudo -u hdfs hadoop fs -mkdir /mapred/system
    sudo -u hdfs hadoop fs -chown mapred:hadoop /mapred/system
}

format_namenode
create_dirs
