# coding: utf-8
# Description:
#   Inspect the data in redis easily
#
# Commands:
#   rubo show users - Display all users that rubo knows about
#   rubo show storage - Display the contents that are persisted in the brain

require 'json'

robot.respond(/show storage$/i) do |message|
  message.send(JSON.pretty_generate(robot.brain.data))
end

robot.respond(/show users$/i) do |message|
  response = ""
  robot.brain.data.users.each_pair do |_, user|
    response += "#{user.id} #{user.name}"
    response += " <#{user.email_address}>" if user.email_address
    response += "\n"
  end
  message.send response
end
