# Load built-in libraries
require 'erb'
require 'log4r/config'
require 'vagrant/ui'
require 'yaml'
# Load custom modules
require 'util/yaml'
# Initialize config loader
config = YAMLTasks.new
# Load project settings
vagrant_settings_dir = File.expand_path('etc/settings', $_VAGRANT_PROJECT_ROOT)
# Load config, initialize variables in global scope
Dir.glob("#{vagrant_settings_dir}/**/*.yaml").each do |config_file|
	config.parse(config_file, 'settings')
end