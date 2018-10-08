module Ecic
  class CLI < Command
      
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
    long_desc Help.text('generate')['long']
    subcommand "generate", Generate

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
  end
end




