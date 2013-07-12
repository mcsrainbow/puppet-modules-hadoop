class common::params {
    # The Puppet workdir
    $workdir = "/opt/puppet-workdir"

    file { "$workdir":
        ensure => "directory",
    }
}
