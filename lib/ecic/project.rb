module Ecic

  class Project

    attr_accessor :libraries
    attr_reader   :root
    
    require 'pathname'
    
    def initialize(root = Project::root)
      @libraries = []
      @root = root
    end

    SCRIPT_ECIC = File.join('src',  'config', 'ecic.rb')
    LIBRARIES_CFG_SCRIPT = File.join('src',  'config', 'libraries.rb')
    
    #Function that returns the root directory of a ECIC project
    #This is used by some generators to check if a command is called 
    #from within an ECIC project folder
    def self.root(path = Pathname.new(Dir.pwd))
      if File.exists?(File.join(path, SCRIPT_ECIC))
        return File.expand_path(path)
      elsif path.root?
        return nil
      end
      return root(path.parent)
    end

    def load_libraries
      lib_file = File.join(@root, LIBRARIES_CFG_SCRIPT)
      if File.exists?(lib_file)
        begin
          eval File.read(lib_file)
        rescue Exception => exc
          raise "Syntax error occurred while reading #{lib_file}: #{exc.message}"
        end
#      else
#        raise "Could not read library definitions from #{lib_file}"
      end
    end

    def has_library?(library)
#      libraries.any? {|l| l.name.eql? library.name  && l.type.to_s.eql? library.type.to_s}
      libraries.any? {|l| l.name.eql? library.name}
    end
      
    def get_library(lib_name)
      matching_libraries = libraries.select {|l| l.name.eql? lib_name }
      raise "Found multiple libraries called '#{lib_name}'" if matching_libraries.length > 1
      matching_libraries.first
    end

    def add_library(lib)
      raise "A library called '#{lib.name}' already exists" if has_library?(lib)
      @libraries << lib
      return true
    end

    #Function used by 'design_library.create' method used in src/confic/libraries.rb
    def design_library(options={})
      Library.new(self, :design, options)
    end

    #Function used by 'testbench_library.create' method used in src/confic/libraries.rb
    def testbench_library(options={})
      Library.new(self, :testbench, options)
    end

    def load_sources
      libraries.each { |lib| lib.load_sources }
    end

  end
end