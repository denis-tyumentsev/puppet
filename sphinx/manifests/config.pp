class sphinx::config inherits sphinx {
  file { '/etc/sphinx/conf.d/':
    ensure  => directory,
    owner   => 'sphinx',
    group   => 'sphinx',
    mode    => '0775',
  }

  define modUserGroups ($user = $title) {
    exec { "Sphinx group membership for: $user":
      unless => "/bin/getent group sphinx|/bin/cut -d: -f4|/bin/grep -q ${user}", # test user exists
      command => "/usr/sbin/usermod -a -G sphinx ${user}",
      #require => Package["sphinx"],
    }
  }
 
  modUserGroups { $config_admins: }
  
  file { '/etc/sphinx/sphinx.conf':
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => 0644,
    content => template("$module_name/sphinx.conf"),
    #replace => 'no',
  }

   file { '/etc/sphinx/indexer.conf':
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => 0644,
    content => template("$module_name/indexer.conf"),
    replace => 'no',
  }

  file { '/etc/sphinx/searchd.conf':
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => 0644,
    content => template("$module_name/searchd.conf"),
    replace => 'no',
  }

  file { $config_index_path:
    ensure  => directory,
    owner   => 'sphinx',
    group   => 'sphinx',
    mode    => '0775',
  }

  file { '/usr/local/bin/sphinx_reindex':
    ensure  => file,
    mode    => '0755',
    content => template("$module_name/sphinx_reindex.erb"),
    replace => 'no',   
  }

}
