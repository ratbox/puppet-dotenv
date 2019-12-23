# Manage .env configuration files

#### Table of Contents

1. [Description](#description)
2. [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
    * [dotenv resource type](#dotenv-defined-type)
    * [dotenv class](#dotenv-class)
    * [Examples](#examples)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Credits](#credits)
6. [Licensing information](#license)

## Description

This Puppet module provides the `dotenv` defined type for managing `.env` files commonly used for storing configuration separately
from application code; see the [The Twelve-Factor App](https://12factor.net/config) methodology for details of this concept.

The module also supplies the `dotenv` function that produces a string representation of `.env` file contents from a Puppet hash.

## Setup Requirements

This module depends on the [puppetlabs/stdlib](https://forge.puppet.com/puppetlabs/stdlib) module.

## Usage

### dotenv defined type

The `dotenv` defined type has the following attributes:

* `path` (namevar) &ndash; absolute path to the `.env` file to manage;
* `ensure` (default: `present`) &ndash; manages the file as `present` or `absent`;
* `mode` (default: `undef`) &ndash; file mode to set ([DAC](https://en.wikipedia.org/wiki/Discretionary_access_control) permissions);
* `owner` (default: `undef`) &ndash; file owner to set;
* `group` (default: `undef`) &ndash; file group to set;
* `force` (default: `false`) &ndash; see the [force attribute](https://puppet.com/docs/puppet/latest/types/file.html#file-attribute-force) of the underlying `file` resource type;
* `entries` &ndash; hash of key-value entries to write into the file.

### dotenv function

The `dotenv` function takes a Puppet hash of key-value entries as its sole parameter and returns a string that represents the corresponding `.env` file contents.

Please see the last example below for a use case.

### Examples

Manage a web application configuration file:

```puppet
dotenv { 'Web app config':
  path    => '/var/www/app/.env',
  mode    => '0400',
  owner   => 'www-data',
  group   => 'www-data',
  entries => {
    'MYSQL_HOSTNAME' => 'localhost',
    'MYSQL_USERNAME' => 'user',
    'MYSQL_PASSWORD' => 'secret',
    'MYSQL_DATABASE' => 'dbname',
  },
}
```

The result in the `/var/www/app/.env` file will be:

```shell
# Managed by Puppet

MYSQL_HOSTNAME="localhost"
MYSQL_USERNAME="user"
MYSQL_PASSWORD="secret"
MYSQL_DATABASE="dbname"
```

Manage a web application configuration file with entries looked up in Hiera:

```puppet
$entries = lookup('app_env', Hash, deep)

dotenv { 'Web app config':
  path    => '/var/www/app/.env',
  mode    => '0400',
  owner   => 'www-data',
  group   => 'www-data',
  entries => $entries,
}
```

Previous example using the base `file` resource type and the `dotenv` function (in case you might want more control over the resource attributes&ndash;note the `backup` attribute):

```puppet
$entries = lookup('app_env', Hash, deep)

file { 'Web app config':
  path    => '/var/www/app/.env',
  backup  => false,
  mode    => '0400',
  owner   => 'www-data',
  group   => 'www-data',
  content => dotenv($entries),
}
```

## Limitations

The `dotenv` defined type is a wrapper around the `file` resource type and implements a narrow subset of its attributes.

## Credits

The `dotenv` function is a stripped down version of the `hash2kv` function from the [mmckinst/hash2stuff](https://forge.puppet.com/mmckinst/hash2stuff)
module by [Mark McKinstry](https://forge.puppet.com/mmckinst).

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
