class hadoop::hue {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::basepackages

    # Install required RPM packages
    $package_list = [ 
                    "hue-plugins",
                    ]
    package { $package_list: ensure => "installed" }
}
