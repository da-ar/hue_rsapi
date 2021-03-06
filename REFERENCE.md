# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Resource types**

* [`hue_light`](#hue_light): This type provides Puppet with the capabilities to manage Philips Hue lights

## Resource types

### hue_light

This type provides Puppet with the capabilities to manage Philips Hue lights

#### Properties

The following properties are available in the `hue_light` type.

##### `on`

Data type: `Optional[Boolean]`

Switches the light on or off

##### `hue`

Data type: `Optional[Integer]`

The colour the light.

##### `bri`

Data type: `Optional[Integer]`

This is the brightness of a light from its minimum brightness 0 to its maximum brightness 254
(note minimum brightness is not off, and the light will actually return 1 when set to 0 and return 254 when set to 255).
This range has been calibrated so there a perceptually similar steps in brightness over the range.
You can set the “bri” resource to a specific value

##### `sat`

Data type: `Optional[Integer]`

The saturation of the hue colour

##### `effect`

Data type: `Optional[Enum[none, colorloop]]`

Enables built in effect

##### `alert`

Data type: `Optional[Enum[none, select]]`

Enables special blink feature

#### Parameters

The following parameters are available in the `hue_light` type.

##### `name`

namevar

Data type: `String`

The name of the light

