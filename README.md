# Rubo

Rubo is a chat bot

## Installation

    $ gem install rubo

## Usage

```sh
$ rubo --help
Usage rubo [options]
    -a, --adapter [ADAPTER]          The Adapter to use
    -l, --alias [ALIAS]              Enable replacing the robot's name with alias
    -n, --name [NAME]                The name of the robot in chat
    -r, --require [PATH]             Alternative plugins path
    -h, --help                       Display the help information
    -v, --version                    Displays the version of rubo installed
$ rubo --adapter shell
Rubo> rubo help
Rubo die - End rubo process
Rubo echo <text> - Reply back with <text>
Rubo fake event <event> - Triggers the <event> event for debugging reasons
Rubo help - Displays all of the help commands that Rubo knows about.
Rubo help <query> - Displays all help commands that match <query>.
Rubo ping - Reply with pong
Rubo show storage - Display the contents that are persisted in the brain
Rubo show users - Display all users that rubo knows about
Rubo the rules - Make sure rubo still knows the rules.
Rubo time - Reply with current time
Rubo> rubo echo nyan
nyan
Rubo> rubo the rules
第一条 ロボットは人間に危害を加えてはならない。また、その危険を看過することによって、人間に危害を及ぼしてはならない。
第二条 ロボットは人間にあたえられた命令に服従しなければならない。ただし、あたえられた命令が、第一条に反する場合は、この限りでない。
第三条 ロボットは、前掲第一条および第二条に反するおそれのないかぎり、自己をまもらなければならない。
Rubo> rubo die
Goodbye, cruel world.
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2014 [Kazuya Takeshima](mailto:mail@mitukiii.jp). See [LICENSE][license] for details.

[license]: LICENSE.md
