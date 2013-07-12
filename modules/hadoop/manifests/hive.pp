class hadoop::hive {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::basepackages

    # Require the zookeeper from zookeeper.pp
    require hadoop::zookeeper

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-hive",
                    ]
    package { $package_list: ensure => "installed" }

    # Update /etc/hive/conf/hive-site.xml
    file { "hive-site.xml":
        path    => "/etc/hive/conf/hive-site.xml",
        mode    => "0644", owner => "hive", group => "hive",
        ensure  => present,
        content => template("hadoop/hive-site.xml.erb"),
        require => Package["hadoop-hive"], # Require Package
    }

    # Copy mysql-connector-java-5.1.24-bin.jar  
    file { "mysql-connector-java-5.1.24-bin.jar":
        path   => "/usr/lib/hive/lib/mysql-connector-java-5.1.24-bin.jar",
        mode   => "0644", owner => "hive", group => "hive",
        source => "puppet:///modules/hadoop/mysql-connector-java-5.1.24-bin.jar",
        require => Package["hadoop-hive"], # Require Package
    }
}
