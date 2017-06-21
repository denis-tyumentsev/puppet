class elasticsearch (
  $cluster_name = $elasticsearch::params::cluster_name,
  $hosts  = $elasticsearch::params::hosts,
  $balancer_hostname = $elasticsearch::params::balancer_hostname,
  $node_master = $elasticsearch::params::node_master,
  $node_data = $elasticsearch::params::node_data,
  $elastic_version = $elasticsearch::params::elastic_version
) inherits elasticsearch::params {
  include elasticsearch::config
}
