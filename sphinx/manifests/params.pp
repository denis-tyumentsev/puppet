class sphinx::params {
  $config_admins = ['mmekhanov', 'utkin_vv', 'noodoo', ]
  $package_ensure = 'present'
  $service_manage = false     # disabled by default. User can stop service and reindex sphinx.
  $service_ensure = 'run'
  $config_index_path = ['/usr/local/var', '/usr/local/var/data']
  $noodoo_path = '/var/www/noodoo/app'
}

