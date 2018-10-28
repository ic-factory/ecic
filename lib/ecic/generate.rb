module Ecic
  class Generate < Command    
    include Ecic::LibraryCreationHelper
    
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
      begin
        project_root_path = Ecic::Project::root
  #project_root_path = Dir.pwd
  #if false
        if project_root_path.nil?
          shell.error set_color("You must be within an ECIC project before calling this command",Thor::Shell::Color::RED)
          exit(1)
        else
  #        shell.say "Generating library in #{project_root_path}"
          project = Project.new(project_root_path)
          project.load_libraries
          names.each { |lib_name|
            #TBA: Add option to generate a testbench library as well
            new_lib = project.design_library(lib_name)
            if new_lib.already_exists?
              say set_color("Library called '#{lib_name}' already exists",Thor::Shell::Color::GREEN)
            else
              shell.error set_color("Library called '#{lib_name}' could not be generated",Thor::Shell::Color::RED) unless generate_library new_lib
            end
          }
        end
      rescue Exception => exc
        shell.error set_color(exc.message,Thor::Shell::Color::RED)
        exit(3)
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
    option :types_package, :type => :boolean, :desc => "Include a package file for type and constant definitions."

    def design(*names)
      begin
        type = options[:type]
        root_dir = Project::root
        if root_dir.nil?
          shell.error set_color("You must be within an ECIC project before calling this command",Thor::Shell::Color::RED)
          exit(1)
        end
        project = Project.new(root_dir)
        project.load_libraries
  #      p project.libraries

        lib = project.design_library(options[:lib])
        unless lib.already_exists?
          unless ok_to_create_library? lib
            say "Operation aborted!"
            raise SystemExit
          end
        end

        names.each { |design_name|
          incl_types_pkg = options[:types_package]
          if type == 'vhdl'
            incl_types_pkg = yes?("Would you like to include a package for type and constant definitions for '#{design_name}'? [y/n]: ") if incl_types_pkg.nil?
          else
            incl_types_pkg ||= false
            if incl_types_pkg
              shell.error set_color("--types_package option does not apply for Verilog/SystemVerilog generation!",Thor::Shell::Color::RED)
              exit(3)
            end
          end
          #Tba 
          if type == 'vhdl'
            generator = DesignGenerator.new
            generator.include_types_pkg = incl_types_pkg
          elsif type == 'sv'
            generator = SvDesignGenerator.new
          else
            shell.error set_color("--type option must be set to either 'vhdl' or 'sv'",Thor::Shell::Color::RED)
            exit(3)
          end
          generator.destination_root = root_dir
          generator.library = lib
          generator.design_name = design_name
          generator.invoke_all
        }
      rescue Exception => exc
        shell.error set_color(exc.message,Thor::Shell::Color::RED)
        exit(3)
      end
      
    end
  end
end

