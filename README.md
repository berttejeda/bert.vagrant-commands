# Overview

In my need to define custom vagrant commands, 

I stumbled upon the undocumented Vagrant **.vagrantplugins** feature.

I hijacked the file to leverage ruby [meta-programming](http://ruby-metaprogramming.rubylearning.com/html/ruby_metaprogramming_3.html) and [yaml](http://yaml.org/YAML_for_ruby.html) parsing to abstract away ruby code exposed as vagrant commands. 

Have a look at the two files that make this possible:

- [.vagrantplugins](.vagrantplugins)
- [commands.yaml](etc/commands.yaml)

You'll note that in the **commands.yaml** file I've defined two commands, `foo` and `bar`, each with their corresponding block of ruby code.

These commands are immediately available to your vagrant environment. You can verify this by issuing `vagrant list-commands`.

I believe this can be a powerful way to augment the behavior of your vagrant deployment.

# Usage Examples

Here's how I use this in my vagrant setup:

Given: 

**commands.yaml**

```
---
definitions:
  commands:
    baremetal:
      name: baremetal
      synopsis: Sets baremetal boolean to true
      execute:
          $baremetal = true
```
**Vagrantfile**

```
if $baremetal
	baremetal = {
	"name"=>"baremetal01", "provider"=>"baremetal", "ip"=>"192.168.1.110", "ssh_user"=>"root", "ssh_port"=>22
	}
	printf "%-#{10}s %s\n", 'node name', 'state'
	# Here I insert logic to ping the baremetal node and report it status
	printf "%-#{10}s %s\n", baremetal['name'], 'running'
	exit
end
```

**vagrant command**

`vagrant baremetal status`

What the above hints at is a unified management of both *bare metal* **and** *virtual* under the vagrant umbrella. Yes, there are plugins that already allow this, but I chose to forgo these in favor of this much more ad hoc approach.

# Caveats

Again, the `.vagrantplugins` file is not officially supported by Hashicorp, so if you encounter a bug, you'll probably have to figure it out on your own or do some internet sleuthing. 

It still remains a means to inject custom ruby code into vagrant.
