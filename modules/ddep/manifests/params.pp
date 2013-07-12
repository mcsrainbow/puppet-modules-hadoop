class ddep::params {
    # Require the common::params from common/params.pp
    require common::params

    # The module workdir
    $moduledir = "${common::params::workdir}/ddep"
    file { "$moduledir":
        ensure => "directory",
    }
}
