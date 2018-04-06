require 'puppet/resource_api'
require 'puppet/resource_api/simple_provider'

require 'puppet/util/network_device/philips_hue/device'

require 'json'
require 'uri'

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
    lights = self.class.hue_get('lights', context.device.connection)

    return [] if lights.nil?

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
    args = {}.tap do |hash|
      hash[:on] = should[:on]
      hash[:bri] = should[:bri] if should[:bri]
      hash[:hue] = should[:hue] if should[:hue]
      hash[:sat] = should[:sat] if should[:sat]
      hash[:effect] = should[:effect] if should[:effect]
      hash[:alert] = should[:alert] if should[:alert]
    end

    self.class.hue_put("lights/#{name}/state", context.device.connection, args)
  end

  def self.hue_get(url, connection, args = nil)
    url = URI.escape(url) if url
    result = connection.get(url, args)
    output = JSON.parse(result.body)
    output
  rescue JSON::ParserError
    return nil
  end

  def self.hue_put(url, connection, message)
    message = message.to_json
    message.gsub!(%r{"false"}, 'false')
    message.gsub!(%r{"true"}, 'true')
    connection.put(url, message)
  end
end
