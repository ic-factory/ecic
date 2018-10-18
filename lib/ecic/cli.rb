module Ecic
  class CLI < Command

    include Ecic::SourceFileAdder
      
    class << self
      def help(shell, subcommand = false)
        shell.say "Usage: ecic COMMAND [ARGS]"
        shell.say ""
        super
        shell.say "To get more help on a specific command, try 'ecic help [COMMAND]'"
      end

      #TBA: Make a function that returns the root folder for the project
      def root
        File.expand_path("./tfj2")
      end
    end

    check_unknown_options!

    #Make sure to return non-zero value if an error is thrown.
    def self.exit_on_failure?
      true
    end

    #--------------------------------------------------------------------------
    # NEW command:
    #--------------------------------------------------------------------------
    desc "new PATH", Help.text('new')['short']
    long_desc Help.text('new')['long']
    option :verbose, :type => :boolean
    def new(path)
      path = File.expand_path(path)
      shell.say "Generating a new project in #{path}"
      generator = ProjectGenerator.new
      generator.destination_root = path
      generator.invoke_all
      
      shell.say "\nTo install the required packages in your project, please run:\n   cd #{path}; bundle install\n", Thor::Shell::Color::BOLD
      #TBA: invoke installation by eg. calling 'bundler install' from within the generated project folder    
#      Bundler.with_clean_env do
#        Dir.chdir(path) do
#          `bundle install`
#        end
#      end
    end

    #--------------------------------------------------------------------------
    # GENERATE command:
    #--------------------------------------------------------------------------
    desc "generate SUBCOMMAND ...ARGS", Help.text('generate')['short']
    subcommand "generate", Generate

    
    #--------------------------------------------------------------------------
    # design generator:
    #--------------------------------------------------------------------------
    desc "addfile LIBRARY_NAME FILENAME...", Help.text('addfile')['short']
    long_desc Help.text('addfile')['long']

    def addfile(lib_name, *file_names)
      begin
        root_dir = Project::root
        if root_dir.nil?
          shell.error "You must be within an ECIC project before calling this command"
          exit(1)
        end
        project = Project.new(root_dir)
        project.load_libraries

        unless project.has_library?(lib_name)
          if yes?("Library '#{lib_name}' does not exist. Create it? [y/n]:")
            generator = LibraryGenerator.new
            generator.destination_root = root_dir
            generator.library_name = lib_name
            generator.invoke_all
          else
            shell.error "Operation aborted!"
            exit(2)
          end
        end
        file_adder = FileAdder.new
        file_adder.library_name = lib_name
        file_adder.file_names = file_names
        file_adder.invoke_all

      rescue Exception => exc
        shell.error exc.message
        exit(3)
      end
      
    end


    #--------------------------------------------------------------------------
    # COMPLETION command:
    #--------------------------------------------------------------------------
    desc "completion *PARAMS", Help.text('completion')['short'], hide: true
    long_desc Help.text('completion')['long']
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    #--------------------------------------------------------------------------
    # COMPLETION_SCRIPT command:
    #--------------------------------------------------------------------------
    desc "completion_script", Help.text('completion')['script']['short'], hide: true
    long_desc Help.text('completion')['script']['long']
    def completion_script
      Completer::Script.generate
    end

    #--------------------------------------------------------------------------
    # VERSION command:
    #--------------------------------------------------------------------------
    desc 'version', 'Display version'
    def version
      say "#{VERSION}"
    end
    
    #--------------------------------------------------------------------------
    # LIBRARIES command:
    #--------------------------------------------------------------------------
    desc 'libraries', Help.text('libraries')['short']
    long_desc Help.text('libraries')['long']
    option :format, :type => :string, :banner => 'text|json', :desc => 'Specify the output format'
    option :include_source_files, :type => :boolean, :aliases => '-s', :desc => "Include source files for each library"
    def libraries

      defaults = {
        "format"       => "text",
        "include_source_files" => false
      }
      opt = defaults.merge(options)
      
      root_dir = Project::root
      if root_dir.nil?
        shell.error "You must be within an ECIC project before calling this command" 
        exit(3)
      end
      project = Project.new(root_dir)
      project.load_libraries
      project.load_sources if opt['include_source_files']
      if opt['format'] == 'json'
        require 'json'
        say project.libraries.map{ |lib| lib.to_json(:include_source_files => opt['include_source_files']) }.join(",") 
      else
        say project.libraries.map{ |lib| lib.to_str(:include_source_files => opt['include_source_files']) }.join("\n") 
      end
    end
  end
end




