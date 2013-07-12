class statsd::params {
    # Require the common::params from common/params.pp
    require common::params

    # The module workdir
    $moduledir = "${common::params::workdir}/statsd"
    file { "$moduledir":
        ensure => "directory",
    }
}
