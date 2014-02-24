# coding: utf-8
# Description:
#   Make sure that rubo knows the rules.
#
# Commands:
#   rubo the rules - Make sure rubo still knows the rules.
#
# Notes:
#   DON'T DELETE THIS SCRIPT! ALL ROBAWTS MUST KNOW THE RULES

rules = {}
rules[:en] = <<-RULES.split("\n").map(&:strip)
  A robot may not injure a human being or, through inaction, allow a human being to come to harm.
  A robot must obey the orders given to it by human beings, except where such orders would conflict with the First Law.
  A robot must protect its own existence as long as such protection does not conflict with the First or Second Law.
RULES
rules[:ja] = <<-RULES.split("\n").map(&:strip)
  第一条 ロボットは人間に危害を加えてはならない。また、その危険を看過することによって、人間に危害を及ぼしてはならない。
  第二条 ロボットは人間にあたえられた命令に服従しなければならない。ただし、あたえられた命令が、第一条に反する場合は、この限りでない。
  第三条 ロボットは、前掲第一条および第二条に反するおそれのないかぎり、自己をまもらなければならない。
RULES

other_rules = {}
other_rules[:en] = <<-RULES.split("\n").map(&:strip)
  A developer may not injure Apple or, through inaction, allow Apple to come to harm.
  A developer must obey any orders given to it by Apple, except where such orders would conflict with the First Law.
  A developer must protect its own existence as long as such protection does not conflict with the First or Second Law.
RULES
other_rules[:ja] = <<-RULES.split("\n").map(&:strip)
  第一条 開発者はAppleに危害を加えてはならない。また、その危険を看過することによって、Appleに危害を及ぼしてはならない。
  第二条 開発者はAppleにあたえられた命令に服従しなければならない。ただし、あたえられた命令が、第一条に反する場合は、この限りでない。
  第三条 開発者は、前掲第一条および第二条に反するおそれのないかぎり、自己をまもらなければならない。
RULES

robot.respond(/(what are )?the (three |3 )?(rules|laws)/i) do |message|
  lang = (ENV['LANG'] || 'en')[0..1].to_sym
  text = (
    if message.message.text.match(/(?:apple|dev)/i)
      other_rules[lang]
    else
      rules[lang]
    end
  )
  message.send(text.join("\n"))
end
