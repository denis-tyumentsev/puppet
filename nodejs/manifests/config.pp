class nodejs::config inherits nodejs {
  if $install_eslint {
    exec { 'install eslint globally' :
      command => 'npm install --global eslint',
      creates => '/usr/bin/eslint',
      user => 'root',
      path => ['/bin', '/usr/bin', '/usr/local/bin']
    }
  }
}
