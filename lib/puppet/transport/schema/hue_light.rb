require 'puppet/resource_api'

Puppet::ResourceApi.register_transport(
  name: 'hue_light',
  docs: <<-EOS,
  This transport provides Puppet with the capabilities to manage Philips Hue lights
EOS
  attributes: {
    name:       {
      type:     'String',
      desc:     'The name of the light',
      behaviour: :namevar,
    },
    on:         {
      type:     'Optional[Boolean]',
      desc:     'Switches the light on or off',
    },
    hue:        {
      type:     'Optional[Integer]',
      desc:     'The colour the light.',
    },
    bri:        {
      type:     'Optional[Integer]',
      desc:     <<DESC,
  This is the brightness of a light from its minimum brightness 0 to its maximum brightness 254
  (note minimum brightness is not off, and the light will actually return 1 when set to 0 and return 254 when set to 255).
  This range has been calibrated so there a perceptually similar steps in brightness over the range.
  You can set the “bri” resource to a specific value
DESC
    },
    sat:        {
      type:     'Optional[Integer]',
      desc:     'The saturation of the hue colour',
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
