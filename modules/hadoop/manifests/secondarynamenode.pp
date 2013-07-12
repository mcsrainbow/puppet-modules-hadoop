class hadoop::secondarynamenode {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::basepackages

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-0.20-secondarynamenode",
                    ]
    package { $package_list: ensure => "installed" }
    
    # Ensure services start on boot and running
    service { "hadoop-0.20-secondarynamenode":
        enable => "true",
        ensure => "running",
        require => Package["hadoop-0.20-secondarynamenode"], # Require Package
    }
}
