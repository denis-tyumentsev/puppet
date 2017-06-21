class noodoo (
  $noodoo_admins = $noodoo::params::noodoo_admins,
#  $noodoo_path  = $noodoo::params::noodoo_path,
  $noodoo_app_name  = $noodoo::params::noodoo_app_name,
  $noodoo_user  = $noodoo::params::noodoo_user,
  $branch  = $noodoo::params::branch,
) inherits noodoo::params {
  include noodoo::config
}
