# == Base Puppet manifest
#
# This manifest declares resource defaults for the Mediawiki-Vagrant
# Puppet site. All Puppet modules bundled with this project have an
# implicit dependency on this manifest and the declarations it contains.
# Modify this file with care.
#
# For more information about resource defaults in Puppet, see
# <http://docs.puppetlabs.com/puppet/2.7/reference/lang_defaults.html>.
#

# By adding a stage => 'first' / 'last' parameter to your class
# declaration, you can tell Puppet to instantiate the class (and its
# resources) at the very beginning of its run or the very end. See:
# <http://docs.puppetlabs.com/puppet/2.7/reference/lang_run_stages.html>
stage { 'first': } -> Stage['main'] -> stage { 'last': }

# Declares a default search path for executables, allowing the path to
# be omitted from individual resources. Also configures Puppet to log
# the command's output if it was unsuccessful.
Exec {
    logoutput => on_failure,
    path      => [ '/bin', '/usr/bin', '/usr/local/bin', '/usr/sbin/' ],
}

Service {
    ensure => running,
}

Package {
    ensure => present,
}

# Declare default uid / gid and permissions for file resources, and
# tells Puppet not to back up configuration files by default.
File {
    backup => false,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
}

file { '/srv':
    owner  => 'vagrant',
    group  => 'www-data',
    mode   => '0755',
}

package { 'python-pip': } -> Package <| provider == pip |>

if $::shared_apt_cache {
    file { '/etc/apt/apt.conf.d/20shared-cache':
        content => "Dir::Cache::archives \"${::shared_apt_cache}\";\n",
    } -> Package <| |>
}
