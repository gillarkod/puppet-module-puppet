# Class: puppet::master
#
# Install and configure puppet master service
#

class puppet::master (
  $master_package_name      = $::puppet::master_package_name,
  $master_package_ensure    = $::puppet::master_package_ensure,
  $master_service_manage    = $::puppet::master_service_manage,
  $master_service_resource  = $::puppet::master_service_resource,
  $master_fileserver_conf   = $::puppet::master_fileserver_config,
) inherits ::puppet {


  include ::puppet::config
  include ::puppet::agent

  if $master_service_manage == true {
    ensure_resource('service', $master_service_resource, { })
    Class['puppet::config'] ~> Service[$master_service_resource] -> Cron['puppet_cron_interval']
  } else {
    Class['puppet::config'] -> Cron['puppet_cron_interval']
  }

  if is_hash($master_fileserver_conf) and empty($master_fileserver_conf) == false {
    create_resources('puppet::fileserver', $master_fileserver_conf)
  }
}
