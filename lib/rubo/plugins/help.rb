# coding: utf-8

# Generates help commands for Rubo.
Rubo::Plugins.register(:help) do |robot|
  robot.add_commands <<-COMMANDS
    rubo help - Displays all of the help commands that Rubo knows about.
    rubo help <query> - Displays all help commands that match <query>.
  COMMANDS

  robot.respond(/help\s*(.*)?$/i) do |message|
    commands = robot.help_commands
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
end
