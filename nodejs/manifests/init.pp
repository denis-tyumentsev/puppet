class nodejs (
  $nodejs_version = $nodejs::params::nodejs_version,
  $package_ensure = $nodejs::params::package_ensure,
  $install_eslint = $nodejs::params::install_eslint,
) inherits nodejs::params {
  include nodejs::install
  include nodejs::config
}
