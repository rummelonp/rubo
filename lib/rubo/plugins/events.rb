# coding: utf-8

require 'json'

# Event system related utilities
Rubo::Plugins.register(:events) do |robot|
  robot.add_commands <<-COMMANDS
    rubo fake event <event> - Triggers the <event> event for debugging reasons
  COMMANDS

  robot.respond(/FAKE EVENT (.*)/i) do |message|
    message.send("fake event '#{message.match[1]}' triggered")
    robot.emit(message.match[1], Hashie::Mash.new(user: message.message.user))
  end

  robot.on(:debug) do |event|
    robot.send(event.user, JSON.pretty_generate(event))
  end
end
