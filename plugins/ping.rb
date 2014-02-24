# coding: utf-8
#   Utility commands surrounding Rubo uptime.
#
# Commands:
#   rubo ping - Reply with pong
#   rubo echo <text> - Reply back with <text>
#   rubo time - Reply with current time
#   rubo die - End rubo process

robot.respond(/PING$/i) do |message|
  message.send('PONG')
end

robot.respond(/ECHO (.*)$/i) do |message|
  message.send(message.match[1])
end

robot.respond(/TIME$/i) do |message|
  message.send("Server time is: #{Time.now}")
end

robot.respond(/DIE$/i) do |message|
  message.send('Goodbye, cruel world.')
  robot.shutdown
end
