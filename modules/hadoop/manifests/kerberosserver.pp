class hadoop::kerberosserver {
    # Require the params from params.pp
    require hadoop::params

    # Require the kerberos from kerberos.pp
    require hadoop::kerberos

    # Install required RPM packages
    $package_list = [ 
                    "krb5-server",
                    ]
    package { $package_list: ensure => "installed" }

    # Update kdc.conf
    file { "kdc.conf":
        path    => "/var/kerberos/krb5kdc/kdc.conf",
        mode    => "0600", owner => "root", group => "root",
        ensure  => present,
        content => template("hadoop/kdc.conf.erb"),
        require => Package["krb5-server"], # Require Package
    }

    # Update kadm5.acl
    file { "kadm5.acl":
        path    => "/var/kerberos/krb5kdc/kadm5.acl",
        mode    => "0600", owner => "root", group => "root",
        ensure  => present,
        content => template("hadoop/kadm5.acl.erb"),
        require => Package["krb5-server"], # Require Package
    }

    # Update taskcontroller.cfg
    file { "taskcontroller.cfg":
        path    => "/etc/hadoop/conf/taskcontroller.cfg",
        mode    => "4754", owner => "root", group => "mapred",
        ensure  => present,
        content => template("hadoop/taskcontroller.cfg.erb"),
        require => Package["krb5-server"], # Require Package
    }

    # Ensure services start on boot and running
    service { "krb5kdc":
        enable => "true",
        ensure => "running",
        require => Package["krb5-server"], # Require Package
    }

    service { "kadmin":
        enable => "true",
        ensure => "running",
        require => Package["krb5-server"], # Require Package
    }

    # Copy the hadoop_kerberos_initialization.sh
    file { "hadoop_kerberos_initialization.sh":
        path   => "${hadoop::params::moduledir}/hadoop_kerberos_initialization.sh",
        mode   => "0755", owner => "root", group => "root",
        source => "puppet:///modules/hadoop/kerberos/hadoop_kerberos_initialization.sh",
        require => Service["krb5kdc"], # Require Service
    }
    # Execute the hadoop_kerberos_initialization.sh
    exec { "hadoop_kerberos_initialization":
        command => "/bin/sh ${hadoop::params::moduledir}/hadoop_kerberos_initialization.sh",
        creates => "/etc/hadoop/conf/hdfs.keytab",
        require => File["hadoop_kerberos_initialization.sh"], # Reauire File
    }
}
