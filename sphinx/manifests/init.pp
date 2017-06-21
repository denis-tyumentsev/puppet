class sphinx (
  $config_admins = $sphinx::params::config_admins,
  $package_ensure = $sphinx::params::package_ensure,
  $service_manage = $sphinx::params::service_manage,
  $config_index_path = $sphinx::params::config_index_path,
  $noodoo_path = $sphinx::params::noodoo_path,
) inherits sphinx::params {
  include sphinx::install
  include sphinx::config
  include sphinx::service
}
