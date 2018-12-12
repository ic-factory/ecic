module Ecic
  class Generate < Command
    include Ecic::LibraryCreationHelper

    #--------------------------------------------------------------------------
    # TESTBENCH generator:
    #--------------------------------------------------------------------------
####    class_option :verbose, :type => :boolean
####    desc "testbench NAME", Help.text('generate')['testbench']['short']
####    long_desc Help.text('generate')['testbench']['long']
####    option :type, :banner => 'vhdl|sv|uvm', :required => true, :desc => 'Specify the testbench type (VHDL, SystemVerilog or UVM)'
####    option :just_print, :type => :boolean, :aliases => '-n', :desc => "Don't actually run any commands; just print them."
####    def testbench(name)
####      puts "Implement a generator for creating a new testbench"
####    end

    #--------------------------------------------------------------------------
    # library generator:
    #--------------------------------------------------------------------------
    desc "library NAME...", Help.text('generate')['library']['short']
    long_desc Help.text('generate')['library']['long']
    option :path, :type => :string, :default => nil, :desc => 'Specify the directory path (relative to the project root) where the associated sources.rb file must be placed.'
    option :type, :type => :string, :default => 'design', :enum => ['design','tb'], :desc => 'Specify whether to create a design or testbench library'
    def library(*names)
      begin
        project_root_path = Ecic::Project::root
        raise "You must be within an ECIC project before calling this command" if project_root_path.nil?
        raise "The --path option may not be used if multiple library names are provided" if names.length > 1
        project = Project.new(project_root_path)
        project.load_libraries
        names.each { |lib_name|
          new_lib = project.library(lib_name, options['type'].to_sym, :path => options['path'])
          generate_library new_lib
        }
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

#    option :just_print, :type => :boolean, :aliases => '-n', :desc => "Don't actually run any commands; just print them."
    option :type, :type => :string, :required => true, :enum => ['vhdl','sv'], :desc => 'Specify the RTL type (VHDL or Verilog/SystemVerilog)'
    option :lib,  :type => :string, :banner => 'LIBRARY_NAME', :required => true, :desc => 'Name of the targeted library'
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
            incl_types_pkg = yes?("Would you like to include a package for type and constant definitions for '#{design_name}'? [y/N]: ") if incl_types_pkg.nil?
          else
            incl_types_pkg ||= false
            raise "--types_package option does not apply for Verilog/SystemVerilog generation!" if incl_types_pkg
          end
          if type == 'vhdl'
            generator = DesignGenerator.new
            generator.include_types_pkg = incl_types_pkg
          elsif type == 'sv'
            generator = SvDesignGenerator.new
          else
            raise "--type option must be set to either 'vhdl' or 'sv'"
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
