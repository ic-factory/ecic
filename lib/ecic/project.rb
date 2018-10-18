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
        return path
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


    def has_library?(lib_name)
      libraries.any? {|l| l.name == lib_name }
    end

#    def add_libray(name)
#      @libraries << Library.new(self, name)
#    end

    #Function used by 'library.create' method used in src/confic/libraries.rb
    def library
      new_lib = Library.new(self)
      libraries << new_lib
      new_lib
    end

    def load_sources
      libraries.each { |lib| lib.load_sources }
    end

  end
end