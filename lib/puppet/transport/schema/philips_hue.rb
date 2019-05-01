require 'puppet/resource_api'

Puppet::ResourceApi.register_transport(
  name: 'philips_hue',
  desc: "Allow's manipulation of a philips hue light setup",

  connection_info: {
    host: {
      type: 'String',
      desc: 'The FQDN or IP address of the hue light system to connect to.',
    },
    key: {
      type: 'String',
      desc: 'The access key that allows access to the hue light system.',
    },
    port: {
      type: 'Optional[Integer]',
      desc: 'The port to use when connecting, defaults to 80.',
    },
  },
)
