class puppet::client (
  $package_name    = $::puppet::client_package_name,
  $package_ensure  = $::puppet::client_package_ensure,
  $agent_service   = $::puppet::client_agent_service,
) inherits ::puppet {

  # Make sure that this class can only be called by this module.
  assert_private('puppet::client is a private class and can not be called directly')

  include ::puppet::config
  include ::puppet::agent

  validate_hash($agent_service)

  # Assert the order in which stuff should execute
  Package['puppet_client'] -> Class['::puppet::config'] -> Cron['puppet_cron_interval']

  package { 'puppet_client':
    ensure => $package_ensure,
    name   => $package_name,
  }
}