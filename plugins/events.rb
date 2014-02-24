# coding: utf-8
# Description:
#   Event system related utilities
#
# Commands:
#   rubo fake event <event> - Triggers the <event> event for debugging reasons
#
# Events:
#   debug - {user: <user object to send message to>}

require 'json'

robot.respond(/FAKE EVENT (.*)/i) do |message|
  message.send("fake event '#{message.match[1]}' triggered")
  robot.emit(message.match[1], Hashie::Mash.new(user: message.message.user))
end

robot.on(:debug) do |event|
  robot.send(event.user, JSON.pretty_generate(event))
end
