# coding: utf-8

require 'hashie/mash'

module Rubo
  # Represents a participating user in the chat.
  class User < Hashie::Mash
    # @param id [Integer] A unique ID for the user.
    # @param options [Hash] An optional Hash of key, value pairs for this user.
    def initialize(id, options = {})
      self.id = id
      options.each_pair do |k, v|
        self[k.to_sym] = v
      end
      self.name ||= id
    end

    # @private
    def dup
      self.class.new(self.id, self)
    end
  end
end
