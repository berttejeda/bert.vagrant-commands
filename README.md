# Overview

In my need to define custom Vagrant commands, 
I stumbled upon the undocumented Vagrant **.vagrantplugins** feature.

I hijacked the file to leverage ruby 
[meta-programming](http://ruby-metaprogramming.rubylearning.com/html/ruby_metaprogramming_3.html) 
and [yaml](http://yaml.org/YAML_for_ruby.html) 
parsing to create custom Vagrant commands.

I believe this can be a powerful way to augment the behavior of your Vagrant deployment.

# How it's done

Here's the sequence of events that make this possible:

| File                                         | Purpose                                                                                            |
|:---------------------------------------------|:---------------------------------------------------------------------------------------------------|
| [.vagrantplugins](.vagrantplugins)           | Initializes the ruby LOAD_PATH and lazy-loads [lib/util/commands.rb](lib/util/commands.rb)         |
| [lib/util/commands.rb](lib/util/commands.rb) | Lazy-loads ruby code under lib/commands to be made available as custom Vagrant commands            |
| [Vagrantfile](Vagrantfile)                   | Loads [lib/config/reader.rb](lib/config/reader.rb) and initializes any virtual machine definitions |
| [lib/config/reader.rb](lib/config/reader.rb) | Initializes global settings values as defined under [etc/settings\/\*.yaml](etc/settings)          |

# etc/settings

As hinted in the table above, any [etc/settings\/\*.yaml](etc/settings) files
are evaluated as [ERB](https://docs.ruby-lang.org/en/2.3.0/ERB.html) templates, with the resulting data structure interpreted as globally-scoped hashes.
Take for example [etc/settings/user.yaml](etc/settings/user.yaml):

```yaml
---
settings:
  user:
    homedir: "<%= File.expand_path('~') %>"
    name: "<%= ENV['USER'] || ENV['USERNAME'] %>"
```

The above will be interpreted as the _$user_ hash object with properties `homedir` and `name`,
whose values are evaluated at runtime, and which can be accessed anywhere in the Vagrantfile 
or in custom commands, as with: `$user.homedir`, `$user.name`.

Note: The `settings` parent key is **not** evaluated as part of the data structure.

# Custom Command Files

Some things to consider:

- A given custom command is just plain ruby code
- Any ruby code you place under [lib/commands\/\*.rb](lib/commands) <br />
  will be interpreted as a Vagrant custom command
- The first line of the command file should be a commented-out line <br />
  This serves as the command's description when you run `vagrant list-commands`

## A demo Custom Command File

As an example, I've included a demo custom command: [lib/commands/demo.rb](lib/commands/demo.rb)

To invoke its help output, you can run `vagrant demo --help`


# Caveats

The `.vagrantplugins` file is not officially supported by Hashicorp, so if you encounter a bug, 
you'll probably have to figure it out on your own or do some internet sleuthing. 

It still remains a readily accessible means to inject custom ruby code into Vagrant.