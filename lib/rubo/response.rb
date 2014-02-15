# coding: utf-8

module Rubo
  # Responses are sent to matching listeners.
  # Messages know about the content and user that made the original message,
  # and how to reply back to them.
  class Response
    # @return [Message]
    attr_reader :message

    # @return [MatchData]
    attr_reader :match

    # @return [Hash]
    attr_reader :envelope

    # @param robot [Robot] A Robot instance.
    # @param message [Message] A Message instance.
    # @param match [MatchData] A Match object from the successful Regex match.
    def initialize(robot, message, match)
      @robot = robot
      @message = message
      @match = match
      @envelope = Hashie::Mash.new(
        room: @message.room,
        user: @message.user,
        message: @message,
      )
    end

    # Posts a message back to the chat source
    #
    # @param strings [Array<String>] One or more strings to be posted.
    #   The order of these strings should be kept intact.
    # @return [void]
    def send(*strings)
      @robot.adapter.send(@envelope, *strings)
    end

    # Posts an emote back to the chat source
    #
    # @param strings [Array<String>] One or more strings to be posted.
    #   The order of these strings should be kept intact.
    # @return [void]
    def emote(*strings)
      @robot.adapter.emote(@envelope, *strings)
    end

    # Posts a message mentioning the current user.
    #
    # @param strings [Array<String>] One or more strings to be posted.
    #   The order of these strings should be kept intact.
    # @return [void]
    def reply(*strings)
      @robot.adapter.reply(@envelope, *strings)
    end

    # Posts a topic changing message
    #
    # @param strings [Array<String>] One or more strings to set as the topic
    #   of the room the bot is in.
    # @return [void]
    def topic(*strings)
      @robot.adapter.topic(@envelope, *strings)
    end

    # Play a sound in the chat source
    # @param strings [Array<String>]
    #   One or more strings to be posted as sounds to play.
    #   The order of these strings should be kept intact.
    # @return [void]
    def play(*strings)
      @robot.adapter.play(@envelope, *strings)
    end

    # Posts a message in an unlogged room
    #
    # @param strings [Array<String>] One or more strings to be posted.
    #   The order of these strings should be kept intact.
    # @return [void]
    def locked(*strings)
      @robot.adapter.locked(@envelope, *strings)
    end

    # Tell the message to stop dispatching to listeners
    #
    # @return [void]
    def finish
      @message.finish
    end
  end
end
