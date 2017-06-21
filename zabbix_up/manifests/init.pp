class zabbix_up  (
  $f_zbx_key_name = $zabbix_up::params::f_zbx_key_name,
  $zbx_filename = $zabbix_up::params::zbx_filename
) inherits zabbix_up::params {
  include zabbix_up::config
}

