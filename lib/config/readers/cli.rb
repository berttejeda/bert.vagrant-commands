require 'util/fso'
include VCMDUtilFSO # loads the fso_mkdir function, among others
@fso = VCMDUtilFSO::Controller.new  

# Clone the ARGV array for later use, rejecting any hyphenated arguments
$vagrant_args = ARGV.clone
$vagrant_args.delete_if { |arg| arg.include?('--') }
$cli_vars = ARGV.clone
$cli_vars.delete_if { |arg| not arg.include?('--__') }
$cli_vars.each do |arg|
	kv = arg.split('=')
	k = kv.first()
	v = kv.last()
	begin
		eval("$#{k.gsub(/--__|-/, '')} = '#{v}'")
	rescue Exception => err
	end
end

# Logging
$debug = [$debug, $logging.debug].any?
$verbose = [$verbose, $logging.verbose].any?

# Logging
$debug = [
	(ARGV.include?('--debug')), 
	ENV['DEBUG'], ENV['debug'], 
	$logging.debug
].any?
$verbose = [
	(ARGV.include?('--verbose')), 
	ENV['VERBOSE'], ENV['verbose'], 
	$logging.verbose
	].any?

# Instantiate the logger method
$logger = Vagrant::UI::Colored.new
# Initialize global variables

# Create required file paths
paths = [
	$logging.logs_dir,
	$vagrant.tmpdir
]
if Dir.pwd == $_VAGRANT_PROJECT_ROOT
	paths.each do |directory|
	  @fso.mkdir(directory)
	end
end
