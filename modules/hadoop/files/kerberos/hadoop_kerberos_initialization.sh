#!/bin/bash
#File Managed by Puppet

function check_root()
{
    if [ $EUID -ne 0 ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi
}

function create_db()
{
    if [ ! -f /var/kerberos/krb5kdc/principal ]; then
        cd /var/kerberos/krb5kdc/
        kdb5_util create -r US-WEST-1.COMPUTE.INTERNAL -s <<EOF
hadoop
hadoop
EOF
    fi
}

function create_keytab()
{
    hive_server="ip-10-196-9-188.us-west-1.compute.internal"
    datanode_list=(
    "ip-10-197-29-251.us-west-1.compute.internal"
    "ip-10-196-9-188.us-west-1.compute.internal"
    "ip-10-197-62-239.us-west-1.compute.internal"
    )

    if [ ! -f /var/kerberos/krb5kdc/hive.keytab ]; then
        cd /var/kerberos/krb5kdc/
        echo "Create Keytab for Hive"
        kadmin.local <<EOF
addprinc -randkey hive/$hive_server@US-WEST-1.COMPUTE.INTERNAL
xst -norandkey -k hive.keytab hive/$hive_server
exit
EOF
    fi

    if [ ! -f /var/kerberos/krb5kdc/hdfs.keytab ]; then
        cd /var/kerberos/krb5kdc/
        for datanode in ${datanode_list[@]} ; do
            echo "Create Keytab for Datanode"
            kadmin.local <<EOF
addprinc -randkey hdfs/$datanode@US-WEST-1.COMPUTE.INTERNAL
addprinc -randkey mapred/$datanode@US-WEST-1.COMPUTE.INTERNAL
addprinc -randkey HTTP/$datanode@US-WEST-1.COMPUTE.INTERNAL
addprinc -randkey hbase/$datanode@US-WEST-1.COMPUTE.INTERNAL
xst -norandkey -k hdfs.keytab hdfs/$datanode
xst -norandkey -k hdfs.keytab HTTP/$datanode
xst -norandkey -k mapred.keytab mapred/$datanode
xst -norandkey -k hbase.keytab hbase/$datanode
exit
EOF
            done
    fi
}

check_root
create_db
create_keytab
