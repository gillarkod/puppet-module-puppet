define puppet::fileserver (
  $config_path  = '/etc/puppetlabs/puppet/fileserver.conf',
  $config_owner = 'root',
  $config_group = 'root',
  $config_mode  = '0644',
  $ensure       = 'present',
  $ini_setting  = 'path',
  $fs_name      = $title,
  $fs_path      = '/etc/puppetlabs/code',
  $auth_setting = { },

) {
  validate_absolute_path($config_path)
  validate_string($config_owner, $config_group, $config_mode)
  validate_string($ini_setting, $name, $path)

  ensure_resource(
    'file',
    $config_path,
    {
      'ensure'  => 'file',
      'owner'   => $config_owner,
      'group'   => $config_group,
      'mode'    => $config_mode
    }
  )

  ini_setting { "${config_path} ${fs_name} ${ini_setting}":
    ensure  => $ensure,
    path    => $config_path,
    section => $fs_name,
    setting => $ini_setting,
    value   => "${fs_path}/${fs_name}",
    key_val_separator => ' ',
  }
  ini_setting { "${config_path} ${fs_name} allow":
    ensure  => $ensure,
    path    => $config_path,
    section => $fs_name,
    setting => 'allow',
    value   => '*',
    key_val_separator => ' ',
  }

  puppet_authorization::rule { "fileserver_$fs_name":
    match_request_path   => "^/file_(metadata|content)s?/${fs_name}/",
    match_request_type   => 'regex',
    match_request_method => ["get", "post"],
    allow                => '*',
    sort_order           => 300,
    path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    notify               => Service['puppetserver']
  }

}
