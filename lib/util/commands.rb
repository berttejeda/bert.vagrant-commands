require 'util/yaml'
require 'util/string'
require 'config/reader'

# Quit if we're not in the project root, because yes.
abort("You're not in the vagrant project root! Exiting.") unless Dir.pwd == $_VAGRANT_PROJECT_ROOT

# Initialize config loader
config = YAMLTasks.new
Dir.glob($vagrant.commands.adhoc.files).each do |cmdf|
  command_name = File.basename(cmdf,".*")
  command_class_name = File.basename(cmdf,".*").capitalize()
  cmdf_first_line = strVar = File.open(cmdf, &:readline)
  if !cmdf_first_line.start_with?('#')
    $logger.error("First line of #{cmdf} must be a comment!")
    next
  end
  command_synopsis = cmdf_first_line[2...-2]
  command_execute = File.read(cmdf)
  _class = """
    Object.const_set('#{command_class_name}', Class.new(Vagrant.plugin(2, :command)){ 
    def self.synopsis() 
      '#{command_synopsis}'
    end
    def execute() 
      #{command_execute}
    end 
  })
  """
  _plugin = """
  Object.const_set('#{command_class_name}_Plugin', Class.new(Vagrant.plugin(2)){ 
    name '#{command_class_name}'
    command '#{command_name}' do 
      #{command_class_name} 
    end 
  })
  """
  eval _class
  eval _plugin
end