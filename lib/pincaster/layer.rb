#!/usr/bin/env ruby

class Pincaster::NoSuchLayer < Exception; end
class Pincaster::LayerError < Exception; end

module Pincaster
  class Layer

    attr_reader   :records, :geo_records, :server
    attr_accessor :name, :type, :distance_accuracy, :latitude_accuracy, :longitude_accuracy, :bounds

    # DEBUG
    attr_accessor :opts

    def initialize(opts={})
      @opts = opts
      @server = opts["server"] || opts[:server] || Pincaster::Server.new
      @name = opts["name"] || opts[:name] || nil
      @records = opts["records"] || opts[:records] || nil
    end

    # Register a new layer
    # @return [Pincaster::Layer]
    def self.register(name, opts={})
      server = opts[:server] || Pincaster::Server.new
      response = server.post "layers/#{name}.json"
      if response && %w(created existing).include?(response['status'])
        Pincaster::Layer.new :name => name, :server => server
      else
        nil
      end
    end

    # Register a layer
    def register
      self.class.register @name, :server => @server
    end

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
        response = server.delete "layers/#{name}.json"
      rescue RestClient::ResourceNotFound
        raise Pincaster::NoSuchLayer
      rescue => err
        raise Pincaster::LayerError.new(response)
      end
      response
    end

    # Delete the layer, raises exception on error
    def delete!
      self.class.delete! @name, @server
    end

    def to_s
      @name
    end
  end
end
