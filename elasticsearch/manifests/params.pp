class elasticsearch::params {
  $cluster_name = 'ELASTIC-CLUSTER'
  $hosts  = '["IP1", "IP2", "IP3", "IP4"]'
  $balancer_hostname = 'name.eurochem.ru'
  $node_master = 'false'
  $node_data = 'true'
  $elastic_version = '5.4.0'
}
