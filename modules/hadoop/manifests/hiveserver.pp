class hadoop::hiveserver {
    # Require the params from params.pp
    require hadoop::params

    # Require the hive from hive.pp
    require hadoop::hive

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-hive-metastore",
                    "hadoop-hive-server",
                    "mysql-server",
                    ]
    package { $package_list: ensure => "installed" }

    # Create required directories
    $directory_list = [
                      "/var/lib/hive",
                      "/var/lib/hive/metastore",
                      ]

    file { $directory_list:
        mode   => "0755", owner  => "hive", group  => "hive",
        ensure => directory,
        require => Package["hadoop-hive"], # Require Package
    }
    
    # Copy the hive_mysqlserver_initialization.sql
    file { "hive_mysqlserver_initialization.sql":
        path   => "${hadoop::params::moduledir}/hive_mysqlserver_initialization.sql",
        mode   => "0644", owner => "root", group => "root",
        source => "puppet:///modules/hadoop/hive_mysqlserver_initialization.sql",
    }

    # Ensure services start on boot and running
    service { "hadoop-hive-metastore":
        enable => "true",
        ensure => "running",
        require => Package["hadoop-hive-metastore"], # Require Package
    }

    service { "hadoop-hive-server":
        enable => "true",
        ensure => "running",
        require => Package["hadoop-hive-server"], # Require Package
    }

    # Copy the hive_initialization.sh
    file { "hive_initialization.sh":
        path   => "${hadoop::params::moduledir}/hive_initialization.sh",
        mode   => "0755", owner => "root", group => "root",
        source => "puppet:///modules/hadoop/hive_initialization.sh",
        require => Service["hadoop-hive-metastore"], # Require Service
    }

    # Execute the hive_initialization.sh
    exec { "hive_initialization":
        command => "/bin/sh ${hadoop::params::moduledir}/hive_initialization.sh",
        unless => "sudo -u hdfs hadoop fs -test -e /user/hive",
        require => File["hive_initialization.sh"], # Reauire File
    }

    # Copy the Hive Kerberos Keytab
    file { "hive.keytab":           
        path    => "/etc/hive/conf/hive.keytab",   
        mode    => "0400", owner => "hive", group => "hive",                                                                          
        source  => "puppet:///modules/hadoop/kerberos/hive.keytab",
    }
}
