require 'uri'
require 'rest-client'
require 'yajl/json_gem'

module Pincaster
  class Server

    attr_reader :uri

    def initialize(*args)
      @config = nil
      self.config *args
      self.uri!
    end

    # Ping server
    #
    # @return [FalseClass] Server does not ping
    # @return [Hash]       The parsed JSON response (ie. server pings...)
    #
    # @todo   Handle exceptions
    def ping
      begin
        JSON.parse RestClient.get((uri + 'system/ping.json').to_s, {:accept => :json})
      rescue => err
        p err
        false
      end
    end

    # Shutdown server
    #
    # @return [FalseClass]
    # @todo   Handle exceptions
    def shutdown!
      begin
        RestClient.post((uri + 'system/shutdown.json').to_s, {:accept => :json})
      rescue => err
        p err
        false
      end
    end

    # Compose the server URI
    # @return [URI]
    def uri!
      @uri = URI.parse "#{@config.http_scheme}://#{@config.host}:#{@config.port}/api/#{@config.api_version}/"
    end

    # Pincaster::Server config
    #
    # @example Set default site
    #   server.config.host = 'localhost'
    #
    # @example Pass a Hash
    #   server.config :host => 'localhost'
    #
    # @example Using a block...
    #   server.config do |conf|
    #    conf.port = 4269
    #   end
    #
    # @return [Struct::PincasterServerConfig]
    def config(*args)
      @config ||= self.class.default_config
      if block_given?
        yield @config
      elsif args.first.respond_to? :merge
        args.first.each_key { |k| @config[k] = args.first[k] }
      end
      @config
    end

    # @private
    @@_default = nil

    # Builds a Struct to hold the default config
    #
    # @private
    # @return [Struct::PincasterServerConfig]
    def self.default_config
      return @@_default if @@_default

      # Default config values. Add array elements to set default config keys:
      #     - element[0] would be the config key, and
      #     - element[1] is the default value.
      defaults = [ [ :host,        'localhost'  ],
                   [ :port,        4269         ],
                   [ :http_scheme, 'http'       ],
                   [ :api_version, '1.0'        ], ]

      conf_struct = Struct.new *defaults.map(&:first).unshift('PincasterServerConfig')
      @@_default = conf_struct.new *defaults.map {|a| a[1]}
    end
  end
end
