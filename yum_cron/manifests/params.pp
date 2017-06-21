class yum_cron::params {
#centos7
  $update_cmd = 'security'
  $update_messages = 'yes'
  $download_updates = 'yes'
  $apply_updates = 'yes'
  $emit_via = 'email'
  $email_to = 'denis.tumentsev@eurochem.ru'
#centos6
  $check_first = 'no'
  $check_only = 'yes'
  $download_only = 'yes'
}
