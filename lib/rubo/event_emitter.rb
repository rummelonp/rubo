# coding: utf-8

module Rubo
  module EventEmitter
    # Adds a listener to the end of the listeners array for the specified event.
    #
    # @overload add_listener(type, once = false, &block)
    #   @param type [Symbol]
    #   @param once [Boolean]
    #   @yield [*args]
    #   @yieldparam args [Array]
    # @overload add_listener(type, once = false, &block)
    #   @param type [Symbol]
    #   @param once [Boolean]
    #   @yield [type, *args]
    #   @yieldparam type [Symbol]
    #   @yieldparam args [Array]
    # @return [void]
    def add_listener(type, once = false, &block)
      id = events.empty? ? 0 : events.last.id + 1
      events << Event.new(
        id: id,
        type: type.to_sym,
        listener: block,
        once: once,
      )
    end

    alias_method :on, :add_listener

    # Adds a one time listener for the event.
    # This listener is invoked only the next time the event is fired,
    # after which it is removed.
    #
    # @param type [Symbol]
    # @yield [*args]
    # @yieldparam [Array] args
    # @return [void]
    def once(type, &block)
      add_listener(type, true, &block)
    end

    # Remove a listener from the id or type for the specified event.
    #
    # @overload remove_listner(id)
    #   @param id [Integer]
    # @overload remove_listner(type)
    #   @param type [Symbol]
    # @return [void]
    def remove_listener(id_or_type)
      if id_or_type.is_a?(Integer)
        events.delete_if { |e| e.id == id_or_type }
      else
        type = id_or_type.to_sym
        events.delete_if { |e| e.type == type }
      end
    end

    # Execute each of the listeners in order with the supplied arguments.
    #
    # @param type [Symbol]
    # @param args [Array]
    # @return [void]
    def emit(type, *args)
      type = type.to_sym
      fired_events = []
      events.each do |e|
        case e.type
        when type
          listener = e.listener
          if listener
            fired_events << e if e.once?
            listener.call(*args)
          end
        when :*
          listener = e.listener
          if listener
            fired_events << e if e.once?
            listener.call(type, *args)
          end
        end
      end
      fired_events.each do |e|
        remove_listener(e.id)
      end
    end

    private

    def events
      @events ||= []
    end

    # @private
    class Event
      attr_reader :id
      attr_reader :type
      attr_reader :listener
      attr_reader :once
      alias_method :once?, :once

      def initialize(attributes = {})
        attributes.each_pair do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end
      end
    end
  end
end
