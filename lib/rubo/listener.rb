# coding: utf-8

require 'rubo/message'

module Rubo
  # Listeners receive every message from the chat source and decide
  # if they want to act on it.
  class Listener
    # @param robot [Robot] A Robot instance.
    # @param matcher [Proc] A Function that determines
    #   if this listener should trigger the callback.
    # @yield [message] Function that is triggered if the incoming message
    # @yieldparam [Response] message
    def initialize(robot, matcher, &block)
      @robot = robot
      @matcher = matcher
      @block = block
    end

    # Determines if the listener likes the content of the message. If so, a
    # Response built from the given Message is passed to the Listener callback.
    #
    # @param message [Message] A Message instance.
    # @return [Boolean]
    def call(message)
      if match = @matcher.call(message)
        if @regex
          @robot.logger.debug "Message '#{message}' matched regex /#{@regex}/"
        end
        @block.call(@robot.response.new(@robot, message, match))
        true
      else
        false
      end
    end
  end

  # TextListeners receive every message from the chat source and decide if they
  # want to act on it.
  class TextListener < Listener
    # @param robot [Robot] A Robot instance.
    # @param regex [Regexp] A Regex that determines
    #   if this listener should trigger the callback.
    # @yield [message] Function that is triggered if the incoming message
    # @yieldparam [Response] message
    def initialize(robot, regex, &block)
      @regex = regex
      matcher = ->(message) do
        if message.is_a?(TextMessage)
          message.match(@regex)
        end
      end
      super(robot, matcher, &block)
    end
  end
end
