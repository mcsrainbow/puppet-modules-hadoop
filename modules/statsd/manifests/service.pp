class statsd::service {
    # Require the params from params.pp
    require statsd::params
    
    # Require the EPEL repo from common/epel.pp
    require common::epel 

    # Install required RPM packages
    $package_list = [ 
                    "nodejs",
                    "npm",
                    ]

    package { $package_list: ensure => "installed" }

    # Install statsd by npm
    exec { "npm-statsd":
        command => "/usr/bin/npm install -g statsd",
        refreshonly => true,
        require => Package["npm"],
        subscribe => File["/etc/statsd.js"], # Subscribe File
    }

    # Update /etc/init/statsd.conf
    file { "statsd.init.upstart":
        path   => "/etc/init/statsd.conf",
        mode   => "0644", owner => "root", group => "root",
        source => "puppet:///modules/statsd/statsd.init.upstart",
        require => Package["npm"], # Require Package
    }

    # Update /etc/statsd.js
    file { "statsd.js":
        path   => "/etc/statsd.js",
        mode   => "0644", owner => "root", group => "root",
        content => template("statsd/statsd.js.erb"),
        require => Package["npm"], # Require Package
    }

    # Restart statsd
    exec { "restart-statsd": 
        command => "/sbin/stop statsd; /sbin/start statsd",
        refreshonly => true,
        subscribe => File["statsd.init.upstart","statsd.js"], # Subscribe File
        require => [Exec["npm-statsd"], File["statsd.init.upstart"]], # Require Exec and Package
    }
}
