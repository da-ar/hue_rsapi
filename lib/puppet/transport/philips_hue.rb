require 'faraday'
require 'uri'
require 'json'

module Puppet::Transport
  class PhilipsHue
    attr_reader :connection

    # @summary 
    #   Initializes and return's a faraday connection to the given host
    def initialize(_context, connection_info)
      port = connection_info[:port].nil? ? 80 : connection_info[:port]
      Puppet.debug "Trying to connect to #{connection_info[:host]}:#{port} with dev key #{connection_info[:key]}"
      @connection = Faraday.new(url: "http://#{connection_info[:host]}:#{port}/api/#{connection_info[:key]}", ssl: { verify: false })
    end


    # @summary 
    #   Return's set facts regarding the class
    def facts(_context)
      { 'operatingsystem' => 'philips_hue' }
    end

    # @summary
    #   Request's api details from the set host
    def hue_get(url, connection, args = nil)
      url = URI.escape(url) if url
      result = connection.get(url, args)
      JSON.parse(result.body)
    rescue JSON::ParserError => e
      raise Puppet::ResourceError, "Unable to parse JSON response from HUE API: #{e}"
    end

    # @summary
    #   Send's an update command to the given url/connection
    def hue_put(url, connection, message)
      message = message.to_json
      connection.put(url, message)
    end


    def verify(_context)
      # Test that transport can talk to the remote target
      # This is a stub method as no such verify method exist and attempts
      #   to implement one indirectly would merely duplicate hue_get().
    end

    def close(_context)
      # Close connection, free up resources
      # This is a stub method as no close method exists in Faraday gem.
    end
  end
end
