module Ecic
  class Generate < Command    
    
    #--------------------------------------------------------------------------
    # TESTBENCH generator:
    #--------------------------------------------------------------------------
####    class_option :verbose, :type => :boolean
####    desc "testbench NAME", Help.text('generate')['testbench']['short']
####    long_desc Help.text('generate')['testbench']['long']
####    option :type, :banner => 'vhdl|sv|uvm', :required => true, :desc => 'Speficy the testbench type (VHDL, SystemVerilog or UVM)'
####    option :just_print, :type => :boolean, :aliases => '-n', :desc => "Don't actually run any commands; just print them."
####    def testbench(name)
####      puts "Implement a generator for creating a new testbench"
####    end

    #--------------------------------------------------------------------------
    # library generator:
    #--------------------------------------------------------------------------
    desc "library NAME...", Help.text('generate')['library']['short']
    long_desc Help.text('generate')['library']['long']
    
    option :just_print, :type => :boolean, :aliases => '-n', :desc => "Don't actually run any commands; just print them."
    def library(*names)
      project_root_path = Ecic::Project::root
#project_root_path = Dir.pwd
#if false
      if project_root_path.nil?
        shell.error "You must be within an ECIC project before calling this command"
        exit(1)
      else
#        shell.say "Generating library in #{project_root_path}"
        names.each { |lib_name|
          generator = LibraryGenerator.new
          generator.destination_root = project_root_path
  #        names.each do |lib_name|
            generator.library_name = lib_name
            generator.invoke_all
  #        end
        }
      end

    end
  end
end

