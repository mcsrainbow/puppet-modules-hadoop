class graphite::params {
    # Require the common::params from common/params.pp
    require common::params

    # The module workdir
    $moduledir = "${common::params::workdir}/graphite"
    file { "$moduledir":
        ensure => "directory",
    }
}
