# coding: utf-8

require 'rubo/event_emitter'
require 'rubo/user'

module Rubo
  # Represents somewhat persistent storage for the robot. Extend this.
  class Brain
    include EventEmitter

    # @return [Hash]
    attr_reader :data

    # Enable or disable the automatic saving
    #
    # @return [Boolean]
    attr_accessor :auto_save
    alias_method :auto_save?, :auto_save

    def initialize(robot)
      @data = Hashie::Mash.new
      data.users = Hashie::Mash.new
      data._private = Hashie::Mash.new
      @auto_save = true
      robot.on(:running) do
        reset_save_interval(5)
      end
    end

    # Store key-value pair under the private namespace and extend existing data
    # before emitting the 'loaded' event.
    #
    # @param key [Symbol]
    # @param value [Object]
    # @return [self]
    def set(key, value)
      data._private.merge(key.to_sym => value)
      emit(:loaded, data)
      self
    end

    # Merge keys loaded from a DB against the in memory representation.
    #
    # @param data [Hash]
    # @return [self]
    def merge_data(data)
      self.data.merge(data)
      emit(:loaded, self.data)
      self
    end

    # Get value by key from the private namespace in data or return nil
    # if not found.
    #
    # @param key [Symbol]
    # @return [Object]
    def get(key)
      data._private[key]
    end

    # Remove value by key from the private namespace in data if it exists
    #
    # @param key [Symbol]
    # @return [self]
    def remove(key)
      data._private.delete(key)
      self
    end

    # Emits the 'save' event so that 'brain' plugins can handle persisting.
    #
    # @return [void]
    def save
      emit(:save, data)
    end

    # Emits the 'close' event so that 'brain' plugins can handle closing.
    #
    # @return [void]
    def close
      @save_thread.exit if @save_thread
      save
      emit(:close)
    end

    # Reset the interval between save function calls.
    #
    # @param seconds [Numeric] An Integer of seconds between saves.
    def reset_save_interval(seconds)
      @save_thread.exit if @save_thread
      @save_thread = Thread.start do
        loop do
          sleep seconds
          save if auto_save
        end
      end
    end

    # Get an Array of User objects stored in the brain.
    #
    # @return [Array<User>]
    def users
      data.users
    end

    # Get a User object given a unique identifier.
    #
    # @param id [Integer]
    # @param options [Hash]
    # @option options [String] :name (id)
    # @option options [String] :room (nil)
    # @return [User]
    def user_for_id(id, options)
      user = users[id]
      if !user
        user = User.new(id, options)
        users[id] = user
      elsif options && options[:room] && (user[:room] == options[:room])
        user = User.new(id, options)
        users[id] = user
      end
      user
    end

    # Get a User object given a name.
    #
    # @param name [String]
    # @return [User]
    def user_for_name(name)
      lower_name = name.downcase
      users.find do |(_, v)|
        user_name = v.name
        if user_name && user_name.downcase == lower_name
          v
        end
      end
    end

    # Get all users whose names match fuzzy name. Currently,
    # match means 'starts with',
    # but this could be extended to match initials, nicknames, etc.
    #
    # @param fuzzy_name [String]
    # @return [Array<User>]
    def users_for_raw_fuzzy_name(fuzzy_name)
      lower_fuzzy_name = fuzzy_name.downcase
      users.values.select do |user|
        user.name.downcase.index(lower_name, 0) == 0
      end
    end

    # If fuzzy name is an exact match for a user,
    # returns an array with just that user.
    # Otherwise, returns an array of all users
    # for which fuzzy name is a raw fuzzy match
    #
    # @see #users_for_raw_fuzzy_name
    # @param fuzzy_name [String]
    # @return [Array<User>]
    def users_for_fuzzy_name(fuzzy_name)
      matched_users = users_for_raw_fuzzy_name(fuzzy_name)
      lower_fuzzy_name = fuzzy_name.downcase
      matched_users.find do |user|
        [user] if user.name.downcase == lower_fuzzy_name
      end
    end
  end
end
