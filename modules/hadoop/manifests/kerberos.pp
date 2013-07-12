class hadoop::kerberos {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::basepackages

    # Require the hbasecommon from hbasecommon.pp
    require hadoop::hbasecommon

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-0.20-sbin","hadoop-0.20-native",
                    "krb5-libs","krb5-devel","krb5-workstation","pam_krb5","cyrus-sasl-gssapi"
                    ]
    package { $package_list: ensure => "installed" }

    # Update JCE Policy Files
    file { "local_policy.jar":
        path    => "/usr/java/jdk1.6.0_41/jre/lib/security/local_policy.jar",
        mode    => "0644", owner => "root", group => "root",
        source  => "puppet:///modules/hadoop/kerberos/local_policy.jar",
    }

    file { "US_export_policy.jar":
        path    => "/usr/java/jdk1.6.0_41/jre/lib/security/US_export_policy.jar",
        mode    => "0644", owner => "root", group => "root",
        source  => "puppet:///modules/hadoop/kerberos/US_export_policy.jar",
    }

   # Update Kerberos Keytab Files
    file { "hdfs.keytab":
        path    => "/etc/hadoop/conf/hdfs.keytab",
        mode    => "0400", owner => "hdfs", group => "hadoop",
        source  => "puppet:///modules/hadoop/kerberos/hdfs.keytab",
    }

    file { "mapred.keytab":
        path    => "/etc/hadoop/conf/mapred.keytab",
        mode    => "0400", owner => "mapred", group => "hadoop",
        source  => "puppet:///modules/hadoop/kerberos/mapred.keytab",
    }

    file { "hbase.keytab":
        path    => "/etc/hbase/conf/hbase.keytab",
        mode    => "0400", owner => "hbase", group => "hbase",
        source  => "puppet:///modules/hadoop/kerberos/hbase.keytab",
    }

    # Update krb5.conf
    file { "krb5.conf":
        path    => "/etc/krb5.conf",
        mode    => "0644", owner => "root", group => "root",
        ensure  => present,
        content => template("hadoop/krb5.conf.erb"),
        require => Package["krb5-libs"], # Require Package
    }
}
