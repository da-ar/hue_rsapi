
# hue_rsapi

The module was created as a simple example of the new way to create a custom Type and Provider using the [Resource API](https://github.com/puppetlabs/puppet-resource_api).


#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with hue_rsapi](#setup)
    * [Setup requirements](#setup-requirements)
    * [Getting started with hue_rsapi](#getting-started-with-hue_rsapi)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


## Module Description

The hue_rsapi module will connect to a Philips Hue hub and retrieve basic details of the lights that are connected to it.

The module enables the retrieval and modification of the data.

## Setup

To install from source, download the tar file from GitHub and run `puppet module install <file_name>.tar.gz --force`.

### Setup Requirements

The module has a dependency on the `resource_api` - it will be installed when the module is installed. Alternatively, it can be manually installed by running `puppet module install puppetlabs-resource_api`, or by following the setup instructions in the [Resource API README](https://github.com/puppetlabs/puppetlabs-resource_api#resource_api).

### Getting started with hue_rsapi

To get started, create or edit `/etc/puppetlabs/puppet/device.conf`, add a section for the device (this will become the device's `certname`), specify a type of `philips_hue`, and specify a `url` to a credentials file. For example:

```INI
[homehub]
type philips_hue
url file:////etc/puppetlabs/puppet/devices/homehub.conf
```

Next, create a credentials file. See the [HOCON documentation](https://github.com/lightbend/config/blob/master/HOCON.md) for information on quoted/unquoted strings and connecting the device.

  ```
default: {
    node: {
      ip: 10.0.10.1
      key: onmdTvd198bMrC6QYyVE9iasfYSeyAbAj3XyQzfL
    }
}
  ```

To obtain an API key for the device follow the steps here: [http://www.developers.meethue.com/documentation/getting-started](http://www.developers.meethue.com/documentation/getting-started)

Test your setup and get the certificate signed:

`puppet device --verbose --target homehub`

This will sign the certificate and set up the device for Puppet.

See the [`puppet device` documentation](https://puppet.com/docs/puppet/5.5/puppet_device.html)

## Usage

Now you can manage your hue_light resources, See: [REFERENCE.md](https://github.com/da-ar/hue_rsapi/blob/master/REFERENCE.md).

### Puppet Device

To get information from the device, use the `puppet device --resource` command. For example, to retrieve addresses on the device, run the following:

`puppet device --resource --target homehub hue_light`

To make changes to the light, write a manifest. Start by making a file named `manifest.pp` with the following content:

```
hue_light { '1':
  on => true,
  bri => 255,
  hue => 39139,
  sat => 255,
  effect => 'colorloop',
  alert => 'none',
}
```

Execute the following command:

`puppet device  --target homehub --apply manifest.pp`

This will apply the manifest. Puppet will check if light is already configured with these settings (idempotency check) and if it finds that it needs to make changes will make the appropriate API calls.

Note that if you get errors, run the above commands with `--verbose` - this will give you error message output.

## Development

This modules has been created for educational reasons, so any updates to the documentation are welcome.

### Testing

#### Unit Testing

Unit tests test the parsing and command generation logic, executed locally.

First execute `bundle exec rake spec_prep` to ensure that the local types are made available to the spec tests. Then execute with `bundle exec rake spec`.

Local testing can be carried out by running:

To retrieve:
```
bundle exec puppet device --verbose --debug --trace --modulepath spec/fixtures/modules --target=homehub --deviceconfig spec/fixtures/device.conf --resource hue_light
```

To set:
```
bundle exec puppet device --verbose --debug --trace --modulepath spec/fixtures/modules --target=homehub --deviceconfig spec/fixtures/device.conf --apply examples/hue_disco.pp
```