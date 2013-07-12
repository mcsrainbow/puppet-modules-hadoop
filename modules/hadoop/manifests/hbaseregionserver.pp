class hadoop::hbaseregionserver {
    # Require the params from params.pp
    require hadoop::params

    # Require the hbasecommon from hbasecommon.pp
    require hadoop::hbasecommon

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-hbase-regionserver",
                    ]
    package { $package_list: ensure => "installed" }

    # Ensure services start on boot and running
    service { "hadoop-hbase-regionserver":
        enable => "true",
        ensure => "running",
        require => Package["hadoop-hbase-regionserver"], # Require Package
    }
}
