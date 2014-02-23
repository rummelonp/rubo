# coding: utf-8

module Rubo
  module Adapters
    # All adapters
    #
    # @return [Hash{Symbol => Class<Adaptable>}]
    def self.adapters
      @adapters ||= {}
    end

    # Load adapter from given name
    #
    # @param adapter_name [Symbol]
    # @param robot [Robot]
    # @return [Adaptable]
    # @raise [LoadError]
    def self.use(adapter_name, robot)
      adapter = find(adapter_name)
      unless adapter
        raise LoadError, "No such adapter \"#{adapter_name}\""
      end
      adapter.new(robot)
    end

    # Find adapter class from given name
    #
    # @param adapter_name [Symbol]
    # @return [Class<Adaptable>]
    def self.find(adapter_name)
      adapters[adapter_name.to_sym]
    end

    # Register adapter
    #
    # @param adapter_name [Symbol]
    # @param adapter_class [Class<Adaptable>]
    def self.register(adapter_name, adapter_class)
      adapters[adapter_name.to_sym] = adapter_class
    end
  end
end

Dir[File.dirname(__FILE__) + '/adapters/*.rb'].each do |file|
  require file
end
