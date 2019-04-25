# Provides a Transport for making calls to Philips Hue lights device(s)
module Puppet::Transport
  # A basic device class, that reads its configuration from the provided URL.
  # The URL has to be a local file URL.
  class HueLight
    attr_reader :connection

    def initialize(url, _options = {})
      @url = URI.parse(url)
      raise Puppet::DevError, "Unexpected url '#{url}' found. Only file:/// URLs for configuration supported at the moment." unless @url.scheme == 'file'

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

    def hue_get(url, connection, args = nil)
      url = URI.escape(url) if url
      result = connection.get(url, args)
      JSON.parse(result.body)
    rescue JSON::ParserError => e
      raise Puppet::ResourceError, "Unable to parse JSON response from HUE API: #{e}"
    end

    def hue_put(url, connection, message)
      message = message.to_json
      connection.put(url, message)
    end

    def transport
      require 'puppet/resource_api/transport'

      @transport[@url] ||= Puppet::ResourceApi::Transport.connect(@url)
   end

    class << self
      attr_reader :connection
    end
  end
end
