# coding: utf-8

module Rubo
  # Represents an incoming message from the chat.
  class Message
    # @return [User]
    attr_reader :user

    # @return [String]
    attr_reader :room

    # @return [Boolean]
    attr_reader :done
    alias_method :done?, :done

    # @param user [User] A User instance that sent the message.
    # @param done [Boolean]
    def initialize(user, done = false)
      @user = user
      @room = user.room
      @done = done
    end

    # Indicates that no other Listener should be called on this object
    def finish
      @done = true
    end
  end

  # Represents an incoming message from the chat.
  class TextMessage < Message
    # @return [String]
    attr_reader :text

    # @param user [User] A User instance that sent the message.
    # @param text [String] A String message.
    # @param id [String] A String of the message ID.
    def initialize(user, text, id = nil)
      super(user)
      @text = text
      @id = id
    end

    # Determines if the message matches the given regex.
    #
    # @param regex [Regexp] A Regex to check.
    def match(regex)
      @text.match(regex)
    end
  end

  # Represents an incoming user entrance notification.
  class EnterMessage < Message
  end

  # Represents an incoming user exit notification.
  class LeaveMessage < Message
  end

  # Represents an incoming topic change notification.
  class TopicMessage < Message
  end

  # Represents a message that no matchers matched.
  class CatchAllMessage < Message
    # @return [Message]
    attr_accessor :message

    # @param message [Message] The original message.
    def initialize(message)
      @message = message
      super(@message.user)
    end
  end
end
