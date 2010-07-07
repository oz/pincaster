#!/usr/bin/env ruby

module Pincaster
  class Layer
    # Register a new layer
    def self.register(name)
      raise "not implemented"
    end

    # Delete a layer
    #
    # @return [TrueClass]  Layer deleted
    # @return [FalseClass] Failed to delete layer
    def self.delete(name)
      raise "not implemented"
    end

    # Delete a layer, raises exception on error
    #
    # @raises [LayerError] Fail
    def self.delete!(name)
      raise "not implemented"
    end

    # List layers
    # @return [Array] List of layer names
    def self.list
      raise "not implemented"
    end
  end
end
