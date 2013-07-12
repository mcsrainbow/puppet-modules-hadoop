class hadoop::hbasemaster {
    # Require the params from params.pp
    require hadoop::params

    # Require the hbasecommon from hbasecommon.pp
    require hadoop::hbasecommon

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-hbase-master",
                    "hadoop-hbase-thrift",
                    ]
    package { $package_list: ensure => "installed" }
    
    # Ensure services start on boot and running
    service { "hadoop-hbase-master":
        enable => "true",
        ensure => "running",
        require => Package["hadoop-hbase-master"], # Require Package
    }

    service { "hadoop-hbase-thrift":
        enable => "true",
        ensure => "running",
        require => Package["hadoop-hbase-thrift"], # Require Package
    }

    # Copy the hbasemaster_initialization.sh
    file { "hbasemaster_initialization.sh":
        path   => "${hadoop::params::moduledir}/hbasemaster_initialization.sh",
        mode   => "0755", owner => "root", group => "root",
        source => "puppet:///modules/hadoop/hbasemaster_initialization.sh",
        require => Service["hadoop-hbase-master"], # Require Service
    }

    # Execute the hbasemaster_initialization.sh
    exec { "hbasemaster_initialization":
        command => "/bin/sh ${hadoop::params::moduledir}/hbasemaster_initialization.sh",
        unless => "sudo -u hdfs hadoop fs -test -e /hbase",
        require => File["hbasemaster_initialization.sh"], # Reauire File
    }
}
