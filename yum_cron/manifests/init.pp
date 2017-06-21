class yum_cron (
  $update_cmd = $yum_cron::params::update_cmd,
  $update_messages = $yum_cron::params::update_messages,
  $download_updates = $yum_cron::params::download_updates,
  $apply_updates = $yum_cron::params::apply_updates,
  $emit_via = $yum_cron::params::emit_via,
  $email_to = $yum_cron::params::email_to,
  $check_first = $yum_cron::params::check_first,
  $check_only = $yum_cron::params::check_only,
  $download_only = $yum_cron::params::download_only,
) inherits yum_cron::params {
  include yum_cron::config
}
