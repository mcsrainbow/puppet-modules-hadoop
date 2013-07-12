class hadoop::hueserver {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::hue

    # Install required RPM packages
    $package_list = [ 
                    "hue",
                    ]
    package { $package_list: ensure => "installed" }

    # Update /etc/hue/hue.ini
    file { "hue.ini":
        path    => "/etc/hue/hue.ini",
        mode    => "0644", owner => "hue", group => "hue",
        ensure  => present,
        content => template("hadoop/hue.ini.erb"),
        require => Package["hue"], # Require Package
    }

    # Update /etc/hue/hue-beeswax.ini
    file { "hue-beeswax.ini":
        path    => "/etc/hue/hue-beeswax.ini",
        mode    => "0644", owner => "hue", group => "hue",
        ensure  => present,
        content => template("hadoop/hue-beeswax.ini.erb"),
        require => Package["hue"], # Require Package
    }

    # Update /etc/hue/hue-shell.ini
    file { "hue-shell.ini":
        path    => "/etc/hue/hue-shell.ini",
        mode    => "0644", owner => "hue", group => "hue",
        ensure  => present,
        content => template("hadoop/hue-shell.ini.erb"),
        require => Package["hue"], # Require Package
    }

    # Ensure services start on boot and running
    service { "hue":
        enable => "true",
        ensure => "running",
        require => File["hue.ini"], # Require File
    }

    # Ensure the setuid permissions
    file { "setuid":
        path   => "/usr/share/hue/apps/shell/src/shell/build/setuid",
        mode   => "4750", owner => "root", group => "hue",
    }
}
