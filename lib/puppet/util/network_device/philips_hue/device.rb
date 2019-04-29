require 'puppet/resource_api/transport/wrapper'

module Puppet::Util::NetworkDevice::Philips_hue # rubocop:disable Style/ClassAndModuleCamelCase
  class Device < Puppet::ResourceApi::Transport::Wrapper
    def initialize(url_or_config, _options = {})
      super('philips_hue', url_or_config)
    end
  end
end
