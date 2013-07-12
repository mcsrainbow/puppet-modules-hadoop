class hadoop::gangliaserver {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::ganglia

    # Include the common:httpd from common/httpd.pp
    include common::httpd

    # Install required RPM packages
    $package_list = [ 
                    "ganglia-gmetad",
                    "ganglia-web",
                    ]
    package { $package_list: ensure => "installed" }

    # Update /etc/ganglia/gmetad.conf 
    file { "gmetad.conf":
        path    => "/etc/ganglia/gmetad.conf",
        mode    => "0644", owner => "ganglia", group => "ganglia",
        ensure  => present,
        content => template("hadoop/gmetad.conf.erb"),
        require => Package["ganglia-gmetad"], # Require Package
        notify  => Service["gmetad"], # Notify the service to restart when changes
    }

    # Update /etc/httpd/conf.d/ganglia.conf
    file { "ganglia.conf":
        path    => "/etc/httpd/conf.d/ganglia.conf",
        mode    => "0644", owner => "ganglia", group => "ganglia",
        ensure  => present,
        content => template("hadoop/httpd_ganglia.conf.erb"),
        require => Package["ganglia-web"], # Require Package
        notify  => Service["httpd"], # Notify the service to restart when changes
    }

    # Ensure services start on boot and running
    service { "gmetad":
        enable => "true",
        ensure => "running",
        require => Package["ganglia-gmetad"], # Require Package
    }
}
