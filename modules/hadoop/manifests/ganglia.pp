class hadoop::ganglia {
    # Require the params from params.pp
    require hadoop::params

    # Require the basepackages from basepackages.pp
    require hadoop::basepackages

    # Require the hbasecommon from hbasecommon.pp
    require hadoop::hbasecommon

    # Install required RPM packages
    $package_list = [ 
                    "ganglia",
                    "ganglia-gmond",
                    ]
    package { $package_list: ensure => "installed" }

    # Update /etc/ganglia/gmond.conf
    file { "gmond.conf":
        path    => "/etc/ganglia/gmond.conf",
        mode    => "0644", owner => "ganglia", group => "ganglia",
        ensure  => present,
        content => template("hadoop/gmond.conf.erb"),
        require => Package["ganglia-gmond"], # Require Package
        notify  => Service["gmond"], # Notify the service to restart when changes
    }

   # Update /etc/hadoop/conf/hadoop-metrics.properties 
   file { "hadoop-metrics.properties":
        path    => "/etc/hadoop/conf/hadoop-metrics.properties",
        mode    => "0644", owner => "hdfs", group => "hadoop",
        ensure  => present,
        content => template("hadoop/hadoop-metrics.properties.erb"),
        require => Package["hadoop-0.20"], # Require Package
   }

   # Update /etc/hbase/conf/hadoop-metrics.properties 
   file { "hbase_hadoop-metrics.properties":
        path    => "/etc/hbase/conf/hadoop-metrics.properties",
        mode    => "0644", owner => "hbase", group => "hbase",
        ensure  => present,
        content => template("hadoop/hbase_hadoop-metrics.properties.erb"),
        require => Package["hadoop-hbase"], # Require Package
   }

    # Ensure service starts on boot and running
    service { "gmond":
        enable => "true",
        ensure => "running",
        require => Package["ganglia-gmond"], # Require Package
    }
}
