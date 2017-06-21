class sphinx::service inherits sphinx {
  if $service_manage {
    service { 'sphinx': 
      enable => true, 
      ensure => $service_ensure, 
      require => Class['sphinx::config'], 
      #subscribe => File['/etc/nginx/conf.d/noodoo.conf'] 
    }
  }
}
