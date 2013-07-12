class graphite::server {
    # Require the params from params.pp
    require graphite::params

    # Require the agent from agent.pp
    require graphite::agent

    # Include the common:httpd from common/httpd.pp
    include common::httpd

    # Install required RPM packages
    $package_list = [ 
                    "libxml2","libxml2-devel",
                    "libxslt","libxslt-devel",
                    "libyaml","PyYAML",
                    "python-setuptools","python-pip","python-devel",
                    "mod_wsgi","mod_python",
                    "bitmap","bitmap-fonts-compat","fontconfig","cairo",
                    "pycairo","python-memcached","python-ldap","python-sqlite2","python-simplejson",
                    "Django","django-tagging",
                    ]

    package { $package_list: ensure => "installed" }

    # Install Graphite
    $pip_list = [
                "twisted","carbon","whisper","txamqp",
                "graphite-web",
                ]
    
    package { $pip_list: 
        ensure   => "installed", 
        provider => "pip", 
        require  => Package["python-setuptools","python-pip","python-devel"], # Require Package 
    }

    # Update /opt/graphite/conf/carbon.conf
    file { "carbon.conf":
        path    => "/opt/graphite/conf/carbon.conf",
        mode    => "0644", owner => "apache", group => "apache",
        ensure  => present,
        content => template("graphite/carbon.conf.erb"),
        require => Package["graphite-web","carbon"], # Require Package
    }
   
    # Update /opt/graphite/conf/storage-schemas.conf
    file { "storage-schemas.conf":
        path    => "/opt/graphite/conf/storage-schemas.conf",
        mode    => "0644", owner => "apache", group => "apache",
        ensure  => present,
        content => template("graphite/storage-schemas.conf.erb"),
        require => Package["graphite-web","carbon"], # Require Package
    }

    # Update /opt/graphite/conf/graphite.wsgi
    file { "graphite.wsgi":
        path    => "/opt/graphite/conf/graphite.wsgi",
        mode    => "0644", owner => "apache", group => "apache",
        ensure  => present,
        content => template("graphite/graphite.wsgi.erb"),
        require => Package["graphite-web","carbon"], # Require Package
    } 

    # Update /etc/httpd/conf.d/graphite-vhost.conf
    file { "graphite-vhost.conf":
        path    => "/etc/httpd/conf.d/graphite-vhost.conf",
        mode    => "0644", owner => "apache", group => "apache",
        ensure  => present,
        content => template("graphite/graphite-vhost.conf.erb"),
        require => Package["graphite-web","carbon"], # Require Package
        notify  => Service["httpd"], # Notify the service to restart when changes
    }

    # Update /opt/graphite/webapp/graphite/local_settings.py
    file { "local_settings.py":
        path    => "/opt/graphite/webapp/graphite/local_settings.py",
        mode    => "0644", owner => "apache", group => "apache",
        ensure  => present,
        content => template("graphite/local_settings.py.erb"),
        require => Package["graphite-web","carbon"], # Require Package
    }

    # Copy the graphite_server_initialization.sh
    file { "graphite_server_initialization.sh":
        path   => "${graphite::params::moduledir}/graphite_server_initialization.sh",
        mode   => "0755", owner => "root", group => "root",
        source => "puppet:///modules/graphite/graphite_server_initialization.sh",
        require => Service["httpd"], # Require Service
    }

    # Execute the graphite_server_initialization.sh
    exec { "graphite_server_initialization":
        command => "/bin/sh ${graphite::params::moduledir}/graphite_server_initialization.sh",
        creates => "/opt/graphite/storage/graphite.db",
        require => File["graphite_server_initialization.sh"], # Reauire File
    }

}
