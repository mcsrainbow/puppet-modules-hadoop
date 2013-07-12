class graphite::agent {
    # Require the EPEL repo from common/epel.pp
    require common::epel

    # Require the params from params.pp
    require graphite::params
}
