class hadoop::basepackages {
    # Require the EPEL repo from common/epel.pp
    require common::epel

    # Require the params from params.pp
    require hadoop::params

    # Install required RPM packages
    $package_list = [ 
                    "hadoop-0.20",
                    ]
    package { $package_list: 
        ensure => "installed",
        require => Exec["jdk-6u41-linux-amd64.rpm","epel-release-6-8.noarch.rpm"], # Require Exec
    }

    # Install Sun JDK
    file { "jdk-6u41-linux-amd64.rpm":
        path   => "${hadoop::params::moduledir}/jdk-6u41-linux-amd64.rpm",
        mode   => "0644", owner => "root", group => "root",
        source => "puppet:///modules/hadoop/jdk-6u41-linux-amd64.rpm",
    }

    exec { 'jdk-6u41-linux-amd64.rpm':
        command => "rpm -ivh ${hadoop::params::moduledir}/jdk-6u41-linux-amd64.rpm",
        creates => "/usr/java/jdk1.6.0_41/bin/java",
        require => File["jdk-6u41-linux-amd64.rpm"], # Require File
    }

    # Create Cloudera yum repo
    file { "cloudera-cdh3u5.repo":
        path   => "/etc/yum.repos.d/cloudera-cdh3u5.repo",
        mode   => "0644", owner => "root", group => "root",
        source => "puppet:///modules/hadoop/cloudera-cdh3u5.repo",
    }

    # Update /etc/hosts
    file { "hosts":
        path    => "/etc/hosts",
        mode    => "0644", owner => "root", group => "root",
        ensure  => present,
        content => template("hadoop/hosts.erb"),
    }

    # Create required directories
    $directory_list = [
                      "/data",
                      ]
    
    file { $directory_list:
        mode   => "0775", owner  => "hdfs", group  => "hadoop",
        ensure => directory,
        require => Package["hadoop-0.20"], # Require Package
    }

    file { "/data/hdfs":
        mode   => "0700", owner  => "hdfs", group  => "hadoop",
        ensure => directory,
        require => Package["hadoop-0.20"], # Require Package
    }

    file { "/data/storage":
        mode   => "1777", owner  => "hdfs", group  => "hadoop",
        ensure => directory,
        require => Package["hadoop-0.20"], # Require Package
    }
   
    # Update /etc/hadoop/conf/hadoop-env.sh
    file { "hadoop-env.sh":
        path    => "/etc/hadoop/conf/hadoop-env.sh",
        mode    => "0755", owner => "hdfs", group => "hadoop",
        ensure  => present,
        content => template("hadoop/hadoop-env.sh.erb"),
        require => Package["hadoop-0.20"], # Require Package
    }

    # Update /etc/hadoop/conf/core-site.xml
    file { "core-site.xml":
        path    => "/etc/hadoop/conf/core-site.xml",
        mode    => "0644", owner => "hdfs", group => "hadoop",
        ensure  => present,
        content => template("hadoop/core-site.xml.erb"),
        require => Package["hadoop-0.20"], # Require Package
    }

    # Update /etc/hadoop/conf/hdfs-site.xml
    file { "hdfs-site.xml":
        path    => "/etc/hadoop/conf/hdfs-site.xml",
        mode    => "0644", owner => "hdfs", group => "hadoop",
        ensure  => present,
        content => template("hadoop/hdfs-site.xml.erb"),
        require => Package["hadoop-0.20"], # Require Package
    }
   
    # Update /etc/hadoop/conf/mapred-site.xml
    file { "mapred-site.xml":
        path    => "/etc/hadoop/conf/mapred-site.xml",
        mode    => "0644", owner => "hdfs", group => "hadoop",
        ensure  => present,
        content => template("hadoop/mapred-site.xml.erb"),
        require => Package["hadoop-0.20"], # Require Package
    }
}
