class noodoo::config inherits noodoo {
  #notify { 'Creating user': }
  user { $noodoo_user:
    name => $noodoo_user,
    ensure => 'present',
    managehome => true,
    uid => 15001,
    #password => '',
    shell => '/bin/bash',
    before => [
      File["/home/$noodoo_user/.ssh"]
      #File["/home/$noodoo_user/.ssh/id_rsa"]
    ],
  }

  file { "/home/$noodoo_user/.ssh":
    ensure => directory,
    owner => $noodoo_user,
    group => $noodoo_user,
    mode => '0700',
  }

  #file { '/home/$noodoo_user/.ssh/id_rsa':
  #  ensure => file,
  #  owner => $noodoo_user,
  #  group => $noodoo_user,
  #  mode => '0600',
  #  source => "puppet:///modules/${module_name}/.ssh/id_rsa",
  #  require => File['/home/$noodoo_user/.ssh'],
  #}

  file { "/home/$noodoo_user/.ssh/authorized_keys":
    ensure => file,
    owner => $noodoo_user,
    group => $noodoo_user,
    mode => '0600',
    require => File["/home/$noodoo_user/.ssh"],
  }

  #notify { 'Creating noodoo directory structure': }
  file { '/var/www':
    ensure => directory,
    owner => 0,
    group => 0,
    replace => 'no',
  }

  file { $noodoo_path:
    ensure => directory,
    owner => $noodoo_user,
    group => $noodoo_user,
    mode => '0775',
    require => [
      File['/var/www'],
      User[$noodoo_user],
    ],
    replace => 'no',
  }

  file { "$noodoo_path/shared": 
    ensure => directory,
    owner => $noodoo_user, 
    group => $noodoo_user, 
    mode => '0775',
    require => File[$noodoo_path], 
    replace => 'no',
  }

  file { "$noodoo_path/shared/pids": 
    ensure => directory,
    owner => $noodoo_user, 
    group => $noodoo_user, 
    mode => '0775',
    require => File["$noodoo_path/shared"], 
    replace => 'no',
  }

  file { "$noodoo_path/shared/pids/noodoo.pid": 
    ensure => file,
    owner => $noodoo_user, 
    group => $noodoo_user, 
    require => File["$noodoo_path/shared/pids"], 
    replace => 'no',
  }

  file { "$noodoo_path/shared/pids/noodoo-queue.pid": 
    ensure => file,
    owner => $noodoo_user, 
    group => $noodoo_user, 
    require => File["$noodoo_path/shared/pids"], 
    replace => 'no',
  }

  file { "$noodoo_path/app": 
    ensure => directory,
    owner => $noodoo_user, 
    group => $noodoo_user, 
    mode => '0775',
    require => File[$noodoo_path], 
    replace => 'no',
  }

  file { "/home/$noodoo_user/noodoo": 
    ensure => link,
    target => "$noodoo_path/app",
    require => File[$noodoo_path], 
    replace => 'no',
  }

  file { "$noodoo_path/bin": 
    ensure => directory,
    owner => $noodoo_user, 
    group => $noodoo_user, 
    mode => '0775',
    require => File[$noodoo_path], 
    replace => 'no',
  }

  file { '/var/log/noodoo': 
    ensure => directory,
    owner => 'root', 
    group => $noodoo_user,
    mode => '0775', 
    replace => 'no',
  }

  file { '/etc/logrotate.d/noodoo': 
    ensure => file,
    owner => 0, 
    group => 0,
    mode => '0644',
    source => "puppet:///modules/${module_name}/logrotate.d/noodoo",
    replace => 'no',
  }

  file { '/tmp/noodoo-uploads': 
    ensure => directory,
    owner => $noodoo_user, 
    group => $noodoo_user,
    mode => '0775', 
    replace => 'no',
  }

  #notify { 'Copy noodoo bin scripts': }
  file { "$noodoo_path/bin/noodoo-installer.sh": 
    ensure => file,
    owner => $noodoo_user, 
    group => $noodoo_user,
    mode => '0775', 
    content => template("$module_name/bin/noodoo-installer.sh.erb"),
    replace => 'no',
    require => File["$noodoo_path/bin"], 
  }

  file { "$noodoo_path/bin/start-noodoo.sh": 
    ensure => file,
    owner => $noodoo_user, 
    group => $noodoo_user,
    mode => '0775', 
    content => template("$module_name/bin/start-noodoo.sh.erb"),
    replace => 'no',
    require => File["$noodoo_path/bin"],
  }

  file { "$noodoo_path/bin/reload-noodoo.sh": 
    ensure => file,
    owner => $noodoo_user, 
    group => $noodoo_user,
    mode => '0775', 
    content => template("$module_name/bin/reload-noodoo.sh.erb"),
    replace => 'no',
    require => File["$noodoo_path/bin"],
  }

  file { "$noodoo_path/bin/start-queue.sh": 
    ensure => file,
    owner => $noodoo_user, 
    group => $noodoo_user,
    mode => '0775', 
    content => template("$module_name/bin/start-queue.sh.erb"),
    replace => 'no',
    require => File["$noodoo_path/bin"],
  }

  file { "$noodoo_path/bin/reload-queue.sh": 
    ensure => file,
    owner => $noodoo_user, 
    group => $noodoo_user,
    mode => '0775', 
    content => template("$module_name/bin/reload-queue.sh.erb"),
    replace => 'no',
    require => File["$noodoo_path/bin"],
  }

  #notify { 'Copy systemd startup scripts': }
  file { "/etc/systemd/system/noodoo.service": 
    ensure => file,
    owner => 0, 
    group => 0,
    content => template("$module_name/system/noodoo.service.erb"),
    replace => 'no',
  }

  file { "/etc/systemd/system/noodoo-queue.service": 
    ensure => file,
    owner => 0, 
    group => 0,
    content => template("$module_name/system/noodoo-queue.service.erb"),
    replace => 'no',
  }

  # TODO: run systemctl enable service
  #notify { 'You should run systemctl enable noodoo service': }

  #notify { 'Copy deploy script files': }
  file { "/usr/local/bin/noodoo_status": 
    ensure => file,
    owner => 0, 
    group => $noodoo_user,
    mode => '0754', 
    source => "puppet:///modules/${module_name}/deploy/noodoo_status",
    replace => 'no',
  }

  file { "/usr/local/bin/noodoo_reload": 
    ensure => file,
    owner => 0, 
    group => $noodoo_user,
    mode => '0754', 
    source => "puppet:///modules/${module_name}/deploy/noodoo_reload",
    replace => 'no',
  }

  file { "/usr/local/bin/noodoo_restart": 
    ensure => file,
    owner => 0, 
    group => $noodoo_user,
    mode => '0754', 
    source => "puppet:///modules/${module_name}/deploy/noodoo_restart",
    replace => 'no',
  }


  #notify { 'Creating sudoers.d entries': }
  file { "/etc/sudoers.d/$noodoo_user":
    ensure => file,
    owner => 0,
    group => 0,
    mode => '0440',
    content => template("$module_name/sudoers.d/sudo_for_user.erb"),
    replace => 'no',
  } 

  # add admins to $noodoo_user group
  define modUserGroups ($user = $title) {
    exec { "Noodoo group membership for: $user":
      unless => "/bin/getent group noodoo | /bin/cut -d: -f4 | /bin/grep -q ${user}",
      command => "/usr/sbin/usermod -a -G noodoo ${user}",
    }
  }

  modUserGroups { $noodoo_admins: }
  
  # add github.com to known_hosts for deploy update to work
  sshkey {'github':
    name => 'github.com',
    ensure => present,
    key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
    type => 'ssh-rsa'
  }
}
