# coding: utf-8

require 'readline'
require 'rubo/adaptable'
require 'rubo/message'

module Rubo
  module Adapters
    # @private
    class Shell
      include Adaptable

      def send(envelope, *strings)
        strings.each do |str|
          puts "\x1b[01;32m#{str}\x1b[0m"
        end
      end

      def emote(envelope, *strings)
        strings.each do |str|
          send(envelope, "* #{str}")
        end
      end

      def reply(envelope, *strings)
        strings = strings.map { |s| "#{envelope.user.name}: #{s}" }
        send(envelope, strings)
      end

      def run
        emit(:connected)
        @running = true
        user = robot.brain.user_for_id(1, name: 'Shell', room: 'Shell')
        while @running && line = Readline.readline("#{robot.name}> ", true)
          return robot.shutdown if line.downcase == 'exit'
          receive(TextMessage.new(user, line, 'messageId'))
        end
      rescue Interrupt
        robot.shutdown
      end

      def close
        @running = false
      end
    end

    register :shell, Shell
  end
end
