require 'faraday'
require 'uri'
require 'hocon'
require 'hocon/config_syntax'
require 'puppet/util/network_device/base'

module Puppet::Util::NetworkDevice::Philips_hue
  # A basic device class, that reads its configuration from the provided URL.
  # The URL has to be a local file URL.
  class Device
    attr_reader :connection

    def initialize(url, _options = {})
      @url = URI.parse(url)
      raise "Unexpected url '#{url}' found. Only file:/// URLs for configuration supported at the moment." unless @url.scheme == 'file'

      Puppet.debug "Trying to connect to #{config['default']['node']['ip']} with dev key #{config['default']['node']['key']}"
      @connection = Faraday.new(url: "http://#{config['default']['node']['ip']}/api/#{config['default']['node']['key']}", ssl: { verify: false })
    end

    def facts
      { 'operatingsystem' => 'philips_hue' }
    end

    def config
      raise "Trying to load config from '#{@url.path}, but file does not exist." unless File.exist? @url.path
      @config ||= Hocon.load(@url.path, syntax: Hocon::ConfigSyntax::HOCON)
    end

    def self.device(url)
      Puppet::Util::NetworkDevice::Philips_hue::Device.new(url)
    end

    class << self
      attr_reader :connection
    end
  end
end
