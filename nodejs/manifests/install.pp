class nodejs::install inherits nodejs {
  case $nodejs_version { 
   '0.12.x': { $repo_path = 'nodejs' }
   '4.x': { $repo_path = 'nodejs4x' }
   '5.x': { $repo_path = 'nodejs5x' }
   '6.x': { $repo_path = 'nodejs6x' }
   default: { fail('Unknown $nodejs_version parameter!') }
  }
  
  yumrepo { 'nodejs':
    baseurl => "http://uds-puppet.moscow.eurochem.ru/${repo_path}/${operatingsystem}/${operatingsystemmajrelease}/${architecture}",
    descr => 'Eurochem Nodejs Repository',
    enabled => 1,
    gpgcheck => 0,
  }

  package { 'nodejs':
    ensure => $package_ensure,
    require => Yumrepo['nodejs'],
  }
}
