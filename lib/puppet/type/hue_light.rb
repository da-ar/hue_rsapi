require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'hue_light',
  docs: <<-EOS,
      This type provides Puppet with the capabilities to manage the Philips Hue lights
    EOS
  attributes: {
    name:       {
      type:     'String',
      desc:     'The name of the light',
      behaviour: :namevar,
    },
    on:         {
      type:     'Optional[Boolean]',
      desc:     'The light is on',
    },
    hue:        {
      type:     'Optional[Integer]',
      desc:     'The colour the light',
    },
    bri:        {
      type:     'Optional[Integer]',
      desc:     'The brightness of the light',
    },
    sat:        {
      type:     'Optional[Integer]',
      desc:     'The saturation of the colour',
    },
    effect:     {
      type:     'Optional[Enum[none, colorloop]]',
      desc:     'Enables built in effect',
    },
    alert:      {
      type:     'Optional[Enum[none, select]]',
      desc:     'Enables special blink feature',
    },
  },
  features: ['remote_resource'],
)
