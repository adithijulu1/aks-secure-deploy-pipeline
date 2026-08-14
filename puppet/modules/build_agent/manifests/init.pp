class build_agent {

  package { ['git', 'docker.io', 'jq', 'unzip']:
    ensure => installed,
  }

  user { 'devopsagent':
    ensure     => present,
    managehome => true,
    groups     => ['docker'],
  }

  file { '/opt/agent':
    ensure => directory,
    owner  => 'devopsagent',
    mode   => '0750',
  }

  exec { 'install-azure-cli':
    command => '/usr/bin/curl -sL https://aka.ms/InstallAzureCLIDeb | bash',
    unless  => '/usr/bin/which az',
    require => Package['jq'],
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker.io'],
  }
}
