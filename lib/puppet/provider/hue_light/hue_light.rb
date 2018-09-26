require 'puppet/resource_api'
require 'puppet/resource_api/simple_provider'
require 'puppet/util/network_device/philips_hue/device'

# Implementation for the hue type using the Resource API.
class Puppet::Provider::HueLight::HueLight
  def set(context, changes)
    changes.each do |name, change|
      if change[:is] != change[:should]
        update(context, name, change[:should])
      end
    end
  end

  def get(context)
    instances = []
    lights = context.device.hue_get('lights', context.device.connection)

    return instances if lights.nil?

    lights.each do |light|
      instances << { name: light.first,
                     on: light.last['state']['on'],
                     bri: light.last['state']['bri'],
                     hue: light.last['state']['hue'],
                     sat: light.last['state']['sat'],
                     effect: light.last['state']['effect'],
                     alert: light.last['state']['alert'] }
    end

    instances
  end

  def update(context, name, should)
    context.device.hue_put("lights/#{name}/state", context.device.connection, should)
  end
end
