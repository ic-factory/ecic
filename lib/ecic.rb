#TBA:
# 1. Create a generator that creates a new (custom) generator
# 2. Add project name and version as options to 'new' generator
# 3. Add option to specify whether separate files must be used (by default) for VHDL entities
#    and architectures.
# 4. Make sure the 'new' action calls 'bundle install' in new project.
# 5. What should the file format be for libraries and source file config files? We want 
#    to be able to automatically add content to these files.
#        sources.yaml
#        sources.yaml.erb
#        sources.rb <- This might be the best option (and have a convention for what it should contain).
#        libraries.rb <- This might be the best option.
# If the user tries to call the 'generate' command outside a project, 
# an error message must be returned stating that this command can only be called from within a project.

require "ecic/version"

module Ecic
  require 'yaml'
  require 'thor'
  require 'thor/group'
  require "ecic/project_generator"
  require "ecic/library_generator"

  def self.help_text
    YAML.load(File.read(File.expand_path("../../config/locales/help.en.yaml", __FILE__)))['help']
  end

  #TBA: Make a function that returns the root folder for the project
  def self.root
    File.expand_path("./tfj2")
  end

  class Generate < Thor
    #--------------------------------------------------------------------------
    # TESTBENCH generator:
    #--------------------------------------------------------------------------
    class_option :verbose, :type => :boolean

    desc "testbench NAME", Ecic::help_text['generators']['testbench']['short']
    long_desc Ecic::help_text['generators']['testbench']['long']
    option :type, :banner => 'vhdl|sv|uvm', :required => true, :desc => 'Speficy the testbench type (VHDL, SystemVerilog or UVM)'
    option :just_print, :type => :boolean, :aliases => '-n', :desc => "Don't actually run any commands; just print them."
    def testbench(name)
      puts "Implement a generator for creating a new testbench"
    end

    desc "library NAME...", Ecic::help_text['generators']['library']['short']
    long_desc Ecic::help_text['generators']['library']['long']
    option :just_print, :type => :boolean, :aliases => '-n', :desc => "Don't actually run any commands; just print them."
#    def library(names)
    def library(lib_name)
      generator = LibraryGenerator.new
      generator.destination_root = Ecic::root
#      names.each do |lib_name|
        generator.library_name = lib_name
        generator.invoke_all
#      end
    end
        
  end  

  class Cli < Thor

    check_unknown_options!

    #Make sure to return non-zero value if an error is thrown.
    def self.exit_on_failure?
      true
    end
    
    class << self
      def help(shell, subcommand = false)
        shell.say "Usage: ecic COMMAND [ARGS]"
        shell.say ""
        super
        shell.say "To get more help on a specific command, try 'ecic help [COMMAND]'"
      end
    end

    #--------------------------------------------------------------------------
    # VERSION command:
    #--------------------------------------------------------------------------
    desc 'version', 'Display version'
    map %w[-v --version] => :version
    def version
      say "#{VERSION}"
    end

    #--------------------------------------------------------------------------
    # NEW command:
    #--------------------------------------------------------------------------
    long_desc Ecic::help_text['new']['long']
    desc "new PATH", Ecic::help_text['new']['short']
    option :verbose, :type => :boolean
    def new(path)
      path = File.expand_path(path)
      puts "Generating a new project in #{path}"
      generator = ProjectGenerator.new
      generator.destination_root = path
      generator.invoke_all
      #TBA: invoke installation by eg. calling 'bundler install' from within the generate project folder
      
    end

    desc "generate SUBCOMMAND ...ARGS", Ecic::help_text['generate']['short']
    subcommand "generate", Generate

  end
  
end
