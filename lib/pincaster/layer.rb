require 'rest-client'

class Pincaster::NoSuchLayer < Exception; end
class Pincaster::LayerAlreadyExist < Exception; end
class Pincaster::LayerError < Exception; end
class Pincaster::NoServer < Exception; end

module Pincaster
  class Layer

    @@accessors = %w(records geo_records server name type distance_accuracy latitude_accuracy longitude_accuracy bounds)
    # Define accessors
    @@accessors.each { |acs|    instance_eval "attr_accessor :#{acs}"  }

    # DEBUG
    attr_accessor :opts

    def initialize(opts={})
      # DEBUG
      @opts = opts
      # Set instance variables for each key/value in opts
      @@accessors.each do |prop|
        value = opts[prop] || opts[prop.to_sym]
        send("#{prop}=", value) if value
      end
    end

    # Define layer-type boolean reader such as:
    # @example
    #   layer = Pincaster::Layer.new :name => 'foo', :type => 'flat'
    #   layer.flat? # true
    #   layer.spherical? # false
    %w(flat flatwrap spherical geoidal).each do |layer_type|
      class_eval %Q(
        def #{layer_type}?
          @type == '#{layer_type}'
        end
      )
    end

    # Register a new layer
    # @param [String] Layer name
    # @param [Hash]   Create options
    # @return [Pincaster::Layer]
    # @raise [LayerError] when opt[:server] is missing
    def self.register(name, opts={})
      raise LayerError.new("no server set") unless opts[:server]
      response = opts[:server].post "layers/#{name}.json"
      if response && %w(created existing).include?(response['status'])
        Pincaster::Layer.new :name => name, :server => opts[:server]
      else
        nil
      end
    end

    # Register a new layer, with an exception if the layer already exist
    # @param [String] Layer name
    # @param [Hash]   Create options
    # @return [Pincaster::Layer]
    # @raise [LayerError] on errors
    # @raise [LayerAlreadyExist] when layer already exists
    def self.register!(name, opts={})
      raise LayerError.new("no server set") unless opts[:server]
      begin
        response = opts[:server].post "layers/#{name}.json"
        raise LayerError.new("no data") unless response || response['status'].nil?
        raise LayerAlreadyExist.new(name) if response['status'] == 'existing'
        Pincaster::Layer.new :name => name, :server => opts[:server]
      rescue => err
        raise LayerError.new err.to_s
      end
    end

    # Register a layer
    def register
      self.class.register @name, :server => @server
    end
    alias :save :register

    # Register a layer
    def register!
      self.class.register! @name, :server => @server
    end
    alias :save! :register!

    # Delete a layer
    # @param [String] layer name
    # @param [Pincaster::Server] Pincaster::Server instance
    # @return [Hash]
    def self.delete(name, server)
      server.delete "layers/#{name}.json"
    end

    # Delete this layer
    #
    # @return [TrueClass]  Layer deleted
    # @return [FalseClass] Failed to delete layer
    def delete
      if response = self.class.delete(@name, @server)
        return false unless response['status'] == 'deleted'
        true
      else
        false
      end
    end
    alias :destroy :delete

    # Delete a layer, raises exception on error
    #
    # @param [String] layer name
    # @param [Pincaster::Server] Pincaster::Server instance
    # @return [Hash]
    #
    # @raises [Pincaster::LayerError] generic error
    # @raises [Pincaster::NoSuchLayer] layer does not exist
    def self.delete!(name, server)
      response = nil
      begin
        raise "no server set" unless server
        response = server.delete "layers/#{name}.json"
      rescue RestClient::ResourceNotFound
        raise Pincaster::NoSuchLayer
      rescue => err
        raise Pincaster::LayerError.new err.to_s
      end
      response
    end

    # Delete the layer, raises exception on error
    def delete!
      self.class.delete! @name, @server
    end
    alias :destroy! :delete!

    def to_s
      @name
    end
  end
end
