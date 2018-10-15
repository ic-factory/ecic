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
          generator.library_name = lib_name
          generator.invoke_all
        }
      end
    end
    
    #--------------------------------------------------------------------------
    # design generator:
    #--------------------------------------------------------------------------
    desc "design NAME...", Help.text('generate')['design']['short']
    long_desc Help.text('generate')['design']['long']
    
    option :just_print, :type => :boolean, :aliases => '-n', :desc => "Don't actually run any commands; just print them."
    option :type, :type => :string, :banner => 'vhdl|sv', :required => true, :desc => 'Speficy the RTL type (VHDL or Verilog/SystemVerilog)'
    option :lib,  :type => :string, :banner => 'LIBRARY_NAME', :required => true, :desc => 'Speficy the RTL type (VHDL or Verilog/SystemVerilog)'
    option :types_package, :type => :boolean, :aliases => '-l', :desc => "Include a package file for type and constant definitions."

    def design(*names)
      begin
        lib_name = options[:lib]
        type = options[:type]
        root_dir = Project::root
        if root_dir.nil?
          shell.error "You must be within an ECIC project before calling this command"
          exit(1)
        end
        project = Project.new(root_dir)
        project.load_libraries
  #      p project.libraries

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

        names.each { |design_name|
          incl_types_pkg = options[:types_package]
          incl_types_pkg ||= yes?("Would you like to include a package for type and constant definitions for '#{design_name}'? [y/n]: ")
          generator = DesignGenerator.new
          generator.destination_root = root_dir
          generator.library_name = lib_name
          generator.design_name = design_name
          generator.include_types_pkg = incl_types_pkg
          generator.invoke_all
        }
      rescue Exception => exc
        shell.error exc.message
        exit(3)
      end
      
    end
  end
end

