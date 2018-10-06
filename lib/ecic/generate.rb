module Ecic
  class Generate < Command    
    
    #--------------------------------------------------------------------------
    # TESTBENCH generator:
    #--------------------------------------------------------------------------
    class_option :verbose, :type => :boolean

    desc "testbench NAME", Help.short_text("generate:testbench")
    long_desc Help.text("generate:testbench")
    option :type, :banner => 'vhdl|sv|uvm', :required => true, :desc => 'Speficy the testbench type (VHDL, SystemVerilog or UVM)'
    option :just_print, :type => :boolean, :aliases => '-n', :desc => "Don't actually run any commands; just print them."
    def testbench(name)
      puts "Implement a generator for creating a new testbench"
    end

    desc "library NAME...", Help.short_text("generate:library")
    long_desc Help.text("generate:library")
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
end
