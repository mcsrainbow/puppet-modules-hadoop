class common::httpd {
    # Install required RPM packages
    $package_list = [ 
                    "httpd",
                    ]
    package { $package_list: ensure => "installed" }

    # Ensure services start on boot and running
    service { "httpd":
        enable => "true",
        ensure => "running",
        require => Package["httpd"], # Require Package
    }
}
