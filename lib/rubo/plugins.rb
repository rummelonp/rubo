# coding: utf-8

module Rubo
  module Plugins
    # All plugins
    #
    # @return [Hash{Symbol => Class<Pluggable>, Proc, #call}]
    def self.plugins
      @plugins ||= {}
    end

    # Load plugin from given name
    #
    # @param plugin_name [Symbol]
    # @param robot [Robot]
    # @return [void]
    # @raise [LoadError]
    def self.use(plugin_name, robot)
      plugin = find(plugin_name)
      unless plugin
        raise LoadError, "No such plugin \"#{plugin_name}\""
      end
      plugin.call(robot)
    end

    # Find plugin class from given name
    #
    # @param plugin_name [Symbol]
    # @return [Class<Pluggable>, Proc, #call]
    def self.find(plugin_name)
      plugins[plugin_name.to_sym]
    end

    # Register plugin
    #
    # @overload register(plugin_name, &block)
    #   @param plugin_name [Symbol]
    #   @yield [robot]
    #   @yieldparam robot [Robot]
    # @overload register(plugin_name, plugin_class)
    #   @param plugin_name [Symbol]
    #   @param plugin_class [Class<Pluggable>, #call]
    # @return [void]
    def self.register(plugin_name, plugin_class = nil, &block)
      plugins[plugin_name.to_sym] = plugin_class || block
    end
  end
end
