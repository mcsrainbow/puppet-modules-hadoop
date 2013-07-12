class hadoop::namenode {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::basepackages

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-0.20-namenode",
                    ]
    package { $package_list: ensure => "installed" }

    # Ensure services start on boot and running
    service { "hadoop-0.20-namenode":
        enable => "true",
        ensure => "running",
        require => Package["hadoop-0.20-namenode"], # Require Package
    }

    # Copy the hadoop_namenode_initialization.sh
    file { "hadoop_namenode_initialization.sh":
        path   => "${hadoop::params::moduledir}/hadoop_namenode_initialization.sh",
        mode   => "0755", owner => "root", group => "root",
        source => "puppet:///modules/hadoop/hadoop_namenode_initialization.sh",
        require => Service["hadoop-0.20-namenode"], # Require Service
    }

    # Execute the hadoop_namenode_initialization.sh
    exec { "hadoop_namenode_initialization":
        command => "/bin/sh ${hadoop::params::moduledir}/hadoop_namenode_initialization.sh",
        creates => "/data/hdfs/current/VERSION",
        require => File["hadoop_namenode_initialization.sh"], # Reauire File
    }
}
