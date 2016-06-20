class puppet::master (
  $master_package_name      = $::puppet::master_package_name,
  $master_package_ensure    = $::puppet::master_package_ensure,
  $master_service_resource  = $::puppet::master_service_resource,
) inherits ::puppet {

  Class['puppet::config'] ~>  Service["${master_service_resource}"] -> Cron['puppet_cron_interval']

  include ::puppet::config
  include ::puppet::agent

  ensure_resource('service', $master_service_resource, { })

}
