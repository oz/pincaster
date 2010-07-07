#!/usr/bin/env ruby

module Pincaster
  class Layer

    attr_reader :opts

    def initialize(opts={})
      @opts = opts
    end

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
  end
end
