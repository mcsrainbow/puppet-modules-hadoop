class common::epel {
    # Create the EPEL repo
    exec { 'epel-release-6-8.noarch.rpm':
        command  => "rpm -ivh http://fr2.rpmfind.net/linux/epel/6/x86_64/epel-release-6-8.noarch.rpm",
        creates  => "/etc/yum.repos.d/epel.repo",
    }
}
