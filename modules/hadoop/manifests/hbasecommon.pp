class hadoop::hbasecommon {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::basepackages

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-hbase",
                    ]
    package { $package_list: ensure => "installed" }

    # Update /etc/hbase/conf/hbase-env.sh
    file { "hbase-env.sh":
        path    => "/etc/hbase/conf/hbase-env.sh",
        mode    => "0644", owner => "hbase", group => "hbase",
        ensure  => present,
        content => template("hadoop/hbase-env.sh.erb"),
        require => Package["hadoop-hbase"], # Require Package
    }

    # Update /etc/hbase/conf/hbase-site.xml
    file { "hbase-site.xml":
        path    => "/etc/hbase/conf/hbase-site.xml",
        mode    => "0644", owner => "hbase", group => "hbase",
        ensure  => present,
        content => template("hadoop/hbase-site.xml.erb"),
        require => Package["hadoop-hbase"], # Require Package
    }
}
