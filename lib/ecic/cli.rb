module Ecic
  class CLI < Command
      
    class << self
      def help(shell, subcommand = false)
        shell.say "Usage: ecic COMMAND [ARGS]"
        shell.say ""
        super
        shell.say "To get more help on a specific command, try 'ecic help [COMMAND]'"
      end
    end

    check_unknown_options!

    #Make sure to return non-zero value if an error is thrown.
    def self.exit_on_failure?
      true
    end

    #TBA: Make a function that returns the root folder for the project
    def self.root
      File.expand_path("./tfj2")
    end
    
#    class_option :verbose, type: :boolean
#    class_option :noop, type: :boolean

    #--------------------------------------------------------------------------
    # NEW command:
    #--------------------------------------------------------------------------
    long_desc Help.text(:new)
    desc "new PATH", Help.short_text(:new)
    option :verbose, :type => :boolean
    def new(path)
      path = File.expand_path(path)
      puts "Generating a new project in #{path}"
      generator = ProjectGenerator.new
      generator.destination_root = path
      generator.invoke_all
      #TBA: invoke installation by eg. calling 'bundler install' from within the generate project folder    
    end

    desc "generate SUBCOMMAND ...ARGS", "sub subcommands"
    long_desc Help.text(:generate)
    subcommand "generate", Generate

    desc "completion *PARAMS", "Print words for auto-completion"
    long_desc Help.text("completion")
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Generate script that can be eval to setup auto-completion", hide: true
    long_desc Help.text("completion_script")
    def completion_script
      Completer::Script.generate
    end

    desc 'version', 'Display version'
    map %w[-v --version] => :version
    def version
      say "#{VERSION}"
    end
  end
end




