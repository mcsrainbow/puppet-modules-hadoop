class hadoop::zookeeper {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::basepackages

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-zookeeper",
                    ]
    package { $package_list: ensure => "installed" }

    # Update /etc/zookeeper/zoo.cfg 
    file { "zoo.cfg":
        path    => "/etc/zookeeper/zoo.cfg",
        mode    => "0644", owner => "zookeeper", group => "zookeeper",
        ensure  => present,
        content => template("hadoop/zoo.cfg.erb"),
        require => Package["hadoop-zookeeper"], # Require Package
    }
}
