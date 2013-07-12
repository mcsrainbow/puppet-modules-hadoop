class ddep::user {
    # Require the params from params.pp
    require ddep::params

    # Create group "ddep"
    group { "ddep":
      ensure => present,
    }

    # Create user "deploy"
    user { "deploy":
      home => "/home/deploy",
      shell => "/bin/bash",
      groups => "ddep",
      managehome => true,
      ensure => present,
      require => Group["ddep"], #Require Group
    }
    
    # Add the SSH public key for user "deploy"
    ssh_authorized_key{ "deploy":
      user => "deploy",
      type => "ssh-rsa",
      name => "deploy@symbio5",
      ensure => present,
      key => "AAAAB3NzaC1yc2EAAAABIwAAAQEA4d1sZ15Or63pty4gV5IZtn7xUp6we3li1DFMcnXVSSOse1sjnhRSWh3HawbzZJhx+1ExWnHx1T9e+2ZqMxIlUHRQPktuddIBaLm63PmCrVDmFyPe17nCgEbemIPYEm7gsknF0R4AQPNLTOOpnof6dbfp+204SoNpLE+e7CbV0Qns5SwNMLEMH33FqymG0KePSbgOLP/8dX13hKkj38W/2O+FYmIjqvcDxOuszIqjnIZa11sHF4hkQrUtMqXlzPIJG7JI+GeuwEBzflQnV7fH+j16UiFYoJJR8eohmPXv3qCAAlu/iEqfbgiDIaIx9WKr/BWnSxBGhttbrlSWnJHskw==",
      require => User["deploy"], #Require User
    }

    # Update /etc/sudoers.d/ddep
    file { "sudoers_ddep":
        path    => "/etc/sudoers.d/ddep",
        mode    => "0440", owner => "root", group => "root",
        ensure  => present,
        content => template("ddep/sudoers_ddep.erb"),
        require => User["deploy"], # Require User
    }
}
