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

    # Define get/post/delete/put methods for Pincaster::Server.
    # Their prototype is the following
    #
    # @param  [String] Path to query
    # @param  [Hash]   RestClient options
    # @return [Hash]   Parsed JSON output
    %w(get post delete put).each do |verb|
      class_eval %Q(
        def #{verb}(path, opts={})
          http_query :#{verb}, uri + path, opts.merge(:accept => :json)
        end
      )
    end

    # Send an HTTP query to a URI, and parse the output as JSON
    #
    # @param [String, Symbol] HTTP verb: 'get', 'post', ...
    # @param [#to_s]          URI to query
    # @param [Hash]           RestClient options
    # @return [Hash]
    def http_query(verb, uri, opts)
      JSON.parse RestClient.send(verb, uri.to_s, opts)
    end

    # Ping server
    #
    # @return [FalseClass] Server does not ping
    # @return [Hash]       The parsed JSON response (ie. server pings...)
    #
    # @todo   Handle exceptions
    def ping
      begin
        get 'system/ping.json'
      rescue => err
        false
      end
    end

    # Shutdown server
    #
    # @return [FalseClass]
    # @todo   Handle exceptions
    def shutdown!
      begin
        post 'system/shutdown.json'
      rescue RestClient::ServerBrokeConnection => died
        true
      rescue => err
        false
      end
    end

    # List layers
    #
    # @return [Array] Array of Pincaster::Layer
    # @todo   Handle exceptions
    def layers
      begin
        response = get 'layers/index.json'
        response['layers'].map { |hash| Pincaster::Layer.new hash.merge(:server => self) }
      rescue => err
        []
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
