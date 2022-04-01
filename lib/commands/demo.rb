# Demo custom commands

options = {}
opt_parser = OptionParser.new do |opt| # https://ruby-doc.org/stdlib-2.6.5/libdoc/optparse/rdoc/OptionParser.html
  opt.banner = "Usage: vagrant demo [foo|bar] [options]"
  opt.separator  ""
  opt.separator  "Options"
  opt.on("-o","--option1 <VALUE>","specify the value for option 1") do |option_1|
    options[:option_1] = option_1
  end
  opt.on("-O","--option2 <VALUE>","specify the value for option 2") do |option_2|
    options[:option_2] = option_2
  end
  opt.on("-C","--show-config","show a value from etc/settings") do |showconfig|
    options[:showconfig] = showconfig
  end  
  opt.on("-r","--run-command <command>","specify a shell command to run") do |runcmd|
    options[:runcmd] = runcmd
  end
  opt.on("-f","--touch-file </path/to/file>","Create an empty file") do |touchfile|
    options[:touchfile] = touchfile
  end  
  opt.on("-h","--help","help") do
    puts opt_parser
    exit
  end
end
opt_parser.parse!

case
when ARGV[1] == 'foo'
  puts "You specified arg foo"
when ARGV[1] == 'bar'
  puts "You specified arg bar with no options"
else
  puts "You didn't specify any arguments"
end

if options[:option_1]
  puts "You specified an option1 value of: #{options[:option_1]}"
end

if options[:option_2]
 puts "You specified an option2 value of: #{options[:option_2]}"
end

if options[:runcmd]
  require 'util/process'
  @process = VCMDUtilProcess::Controller.new  
  puts "Running command '#{options[:runcmd]}'"
  @process.run(options[:runcmd])
end

if options[:touchfile]
  require 'util/process'
  @fso = VCMDUtilFSO::Controller.new
  puts "Creating file #{options[:touchfile]} with contents 0000"
  @fso.write(options[:touchfile], '0000')
end

if options[:showconfig]
  puts "Displaying username and homedir values from etc/settings/user.yaml"
  puts "Your username is #{$user.name} and your homedir is #{$user.homedir}"
end

if ! [
    options[:option_1], 
    options[:option_2], 
    options[:runcmd], 
    options[:showconfig], 
    $logging.debug
  ].any?
puts "You didn't specify any options"
end