class yum_cron::config inherits yum_cron {

 package { 'yum-cron':
      ensure => present,
 } 

 service { 'yum-cron':
    ensure  => 'running',
    enable  => true,
  }

if $operatingsystem == "CentOS" {
  case $operatingsystemrelease {
   /^6.*/: {
     file { "/etc/sysconfig/yum-cron":
       notify  => Service['yum-cron'],
       ensure => file,
       mode => '0644',
       content => template("$module_name/yum-cron_centos6.erb"),
       replace => 'yes',
       require => Package['yum-cron'],
     }
   }
   /^7.*/: {
     file { "/etc/yum/yum-cron.conf":
       notify  => Service['yum-cron'],
       ensure => file,
       mode => '0644',
       content => template("$module_name/yum-cron_centos7.conf.erb"),
       replace => 'yes',
       require => Package['yum-cron'],
     }
   }
  }
}
}
