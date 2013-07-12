class hadoop::params {
    # Require the common::params from common/params.pp
    require common::params

    # The module workdir
    $moduledir = "${common::params::workdir}/hadoop"
    file { "$moduledir":
        ensure => "directory",
    }
}
