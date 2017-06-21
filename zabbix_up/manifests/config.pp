class zabbix_up::config inherits zabbix_up {
  service { 'zabbix-agent':
    ensure  => 'running',
    enable  => true,
  }

  notify { 'Copy userparameter config file': }
  file { "/etc/zabbix/zabbix_agentd.d/userparameter_$zbx_filename.conf":
    notify  => Service['zabbix-agent'],
    ensure => file,
    owner => 'zabbix',
    group => 'zabbix',
    mode => '0644',
    content => template("$module_name/userparameter.conf.erb"),
    replace => 'yes',
  }

  file { '/etc/zabbix/scripts':
    ensure => directory,
    owner => 'zabbix',
    group => 'zabbix',
    mode => '0755',
  }

  notify { 'Copy script file': }
  file { "/etc/zabbix/scripts/$zbx_filename.sh":
    ensure => file,
    owner => 'zabbix',
    group => 'zabbix',
    mode => '0754',
    source => "puppet:///modules/${module_name}/$zbx_filename.sh",
    replace => 'yes',
  }
#  exec { 'set up timeout=10' :
#       notify  => Service['zabbix-agent'],
#       path => '/bin:/usr/bin',
#       command => 'sed -i "s|^# Timeout=3| Timeout=10|" /etc/zabbix/zabbix_agentd.conf'
# }
}
