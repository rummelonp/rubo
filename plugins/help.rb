# coding: utf-8
# Description:
#   Generates help commands for Rubo.
#
# Commands:
#   rubo help - Displays all of the help commands that Rubo knows about.
#   rubo help <query> - Displays all help commands that match <query>.
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.

robot.respond(/help\s*(.*)?$/i) do |message|
  commands = robot.commands
  filter = message.match[1]
  if filter
    regex = Regexp.new(filter)
    commands = commands.select do |command|
      command.match(regex)
    end
  end
  if commands.empty?
    message.send("No available commands match #{filter}")
  else
    prefix = robot.alias_name || robot.name
    commands = commands.map do |command|
      command.sub(/^rubo/i, prefix.to_s)
        .sub(/rubo/i, robot.name.to_s)
    end
    message.send(commands.join("\n"))
  end
end
