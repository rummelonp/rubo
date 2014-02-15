# coding: utf-8

require 'rubo/event_emitter'

module Rubo
  # An adaptable is a specific interface to a chat source for robots.
  #
  # @abstract
  module Adaptable
    include EventEmitter

    # @return [Robot]
    attr_reader :robot

    # @param robot [Robot]
    # @return [Adaptable]
    def initialize(robot)
      @robot = robot
    end

    # Raw method for sending data back to the chat source. Extend this.
    #
    # @abstract
    # @param envelope [Hash] A Hash with message, room and user details.
    # @param strings [Array<String>]
    #   One or more Strings for each message to send.
    # @return [void]
    def send(envelope, *strings)
    end

    # Raw method for sending emote data back to the chat source.
    # Defaults as an alias for send
    #
    # @abstract
    # @param envelope [Hash] A Hash with message, room and user details.
    # @param strings [Array<String>]
    #   One or more Strings for each message to send.
    # @return [void]
    def emote(envelope, *strings)
      send(envelope, *strings)
    end

    # Raw method for building a reply and sending it back to the chat source.
    # Extend this.
    #
    # @abstract
    # @param envelope [Hash] A Hash with message, room and user details.
    # @param strings [Array<String>] One or more Strings for each reply to send.
    # @return [void]
    def reply(envelope, *strings)
    end

    # Raw method for setting a topic on the chat source. Extend this.
    #
    # @abstract
    # @param envelope [Hash] A Hash with message, room and user details.
    # @param strings [Array<String>] One more more Strings to set as the topic.
    # @return [void]
    def topic(envelope, *strings)
    end

    # Raw method for playing a sound in the chat source. Extend this.
    #
    # @abstract
    # @param envelope [Hash] A Hash with message, room and user details.
    # @param strings [Array<String>]
    #   One or more strings for each play message to send.
    # @return [void]
    def play(envelope, *strings)
    end

    # Raw method for invoking the bot to run. Extend this.
    #
    # @abstract
    # @return [void]
    def run
    end

    # Raw method for shutting the bot down. Extend this.
    #
    # @abstract
    # @return [void]
    def close
    end

    # Dispatch a received message to the robot.
    #
    # @abstract
    # @return [void]
    def receive(message)
      @robot.receive(message)
    end
  end
end
