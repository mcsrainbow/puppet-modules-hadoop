class hadoop::zookeeperserver {
    # Require the params from params.pp
    require hadoop::params

    # Require the zookeeper from zookeeper.pp
    require hadoop::zookeeper

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-zookeeper-server",
                    ]
    package { $package_list: ensure => "installed" }
    
    # Create required directories
    $directory_list = [
                      "/data/zookeeper",
                      ]
    
    file { $directory_list:
        mode   => "0775", owner  => "zookeeper", group  => "zookeeper",
        ensure => directory,
        require => Package["hadoop-zookeeper-server"], # Require Package
    }

    # Update /data/zookeeper/myid
    file { "zookeeper_myid":
        path    => "/data/zookeeper/myid",
        mode    => "0644", owner => "zookeeper", group => "zookeeper",
        ensure  => present,
        content => template("hadoop/myid.erb"),
        require => File["/data/zookeeper"], # Require File
    }

    # Ensure services start on boot and running
    service { "hadoop-zookeeper-server":
        enable => "true",
        ensure => "running",
        require => Package["hadoop-zookeeper-server"], # Require Package
    }
}
