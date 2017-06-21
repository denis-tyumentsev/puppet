class elasticsearch::config inherits elasticsearch {

  service { 'elasticsearch':
    ensure  => 'running',
    enable  => true,
  }

  exec { 'rpm import for elastic repo' :
    path => '/bin:/usr/bin',
    command => "bash -c 'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch'"
  }

  file { '/etc/yum.repos.d/elasticsearch.repo': 
    ensure => file,
    owner => 0, 
    group => 0,
    mode => '0644',
    source => "puppet:///modules/${module_name}/yum.repos.d/elasticsearch.repo",
    replace => 'no',
  }

  file { '/etc/yum.repos.d/oracle-java.repo':
    ensure => file,
    owner => 0,
    group => 0,
    mode => '0644',
    source => "puppet:///modules/${module_name}/yum.repos.d/oracle-java.repo",
    replace => 'no',
  }

  exec { 'install elastic and java':
    path => '/bin:/usr/bin',
    command =>"yum install java elasticsearch-$elastic_version -y \
    && systemctl enable elasticsearch"
  }

  if $node_master == 'true' {
    $node_data = 'false'
    service { 'elasticsearch-head':
      ensure  => 'running',
      enable  => true,
    }
    service { 'nginx':
      ensure  => 'running',
      enable  => true,
    }
    file { '/etc/yum.repos.d/nodejs.repo':
      ensure => file,
      owner => 0,
      group => 0,
      mode => '0644',
      source => "puppet:///modules/${module_name}/yum.repos.d/nodejs.repo",
      replace => 'no',
    }
    exec { "install head plugin, nginx":
      path => '/bin:/usr/bin',
      command => "bash -c 'yum install epel-release nginx git nodejs bzip2 -y \
      && systemctl enable nginx \
      && git clone git://github.com/mobz/elasticsearch-head.git /opt/elasticsearch-head \
      && cd /opt/elasticsearch-head \
      && npm install -g grunt-cli \
      && npm install \
      && systemctl enable elasticsearch-head \
      && firewall-cmd --permanent --add-service=http \
      && firewall-cmd --reload'",
      unless => 'ls /opt/elasticsearch-head'
    }
    file { "/etc/nginx/conf.d/elk.conf":
      notify  => Service['nginx'],
      ensure => file,
      owner => 0,
      group => 0,
      mode => '0644',
      content => template("$module_name/elk.conf.erb"),
      replace => 'yes',
    }
    file { "/etc/systemd/system/elasticsearch-head.service":
      notify  => Service['elasticsearch-head'],
      ensure => file,
      owner => 0,
      group => 0,
      mode => '0644',
      source => "puppet:///modules/${module_name}/systemd/elasticsearch-head.service",
      replace => 'yes',
    }
  }

  exec { 'Edit systemd and firewalld' :
    path => '/bin:/usr/bin:/usr/sbin',
    command => 'echo -e "\nMAX_LOCKED_MEMORY=unlimited" >> /etc/sysconfig/elasticsearch \
    && sed -i "s,#LimitMEMLOCK=infinity,LimitMEMLOCK=infinity,g"  /usr/lib/systemd/system/elasticsearch.service \
    && sed -i "s,#LimitNOFILE=65536,LimitNOFILE=65536,g"  /usr/lib/systemd/system/elasticsearch.service \
    && systemctl daemon-reload \
    && firewall-cmd --permanent --add-port=9200/tcp --add-port=9300/tcp \
    && firewall-cmd --reload \
    && echo "vm.swappiness=1" >> /etc/sysctl.conf \
    && sysctl -w vm.swappiness=1'
  }

  file { "/etc/elasticsearch/elasticsearch.yml":
    notify  => Service['elasticsearch'],
    ensure => file,
    owner => 0,
    group => elasticsearch,
    mode => '0660',
    content => template("$module_name/elasticsearch.yml.erb"),
    replace => 'yes',
  }

  exec { 'install plugins' :
    path => '/bin:/usr/bin:/usr/share/elasticsearch/bin',
    command => "elasticsearch-plugin install http://dl.bintray.com/content/imotov/elasticsearch-plugins/org/elasticsearch/elasticsearch-analysis-morphology/$elastic_version/elasticsearch-analysis-morphology-$elastic_version.zip \
    && elasticsearch-plugin install https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-ukrainian/analysis-ukrainian-$elastic_version.zip",
    unless  => 'elasticsearch-plugin list | grep analysis'
  }
}
