# @summary dotenv defined type
#
# Defined file-like type to manage .env files
#
# @example
#   dotenv { '/var/www/mpab/.env':
#     mode    => '0400',
#     owner   => 'www-data',
#     group   => 'www-data',
#     entries => {
#       'APP_NAME' => 'M-Pab',
#       'APP_DESC' => 'Mental Pabulum',
#     },
#   }

define dotenv (
  Hash                       $entries,
  Enum['present', 'absent']  $ensure  = 'present',
  Stdlib::Absolutepath       $path    = $name,
  Boolean                    $force   = false,
  Optional[Stdlib::Filemode] $mode    = undef,
  Optional[String[1]]        $owner   = undef,
  Optional[String[1]]        $group   = undef,
) {
  file { $name:
    ensure  => $ensure,
    path    => $path,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    force   => $force,
    content => dotenv($entries),
  }
}

# vim: ts=2 sw=2 et
