# The file /etc/puppet/manifests/site.pp contains options that apply to 
# the whole site. Let's make it and add the following contents.
import "nodes"

# The filebucket is for backups. Originals of files that Puppet modifies
# get stored here.
filebucket { main: server => puppetmaster }
File { backup => main }

# Set the default $PATH for executing commands on node systems.
Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }
