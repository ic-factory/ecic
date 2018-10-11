module Ecic

  class Project

    attr_accessor :libraries
    
    require 'pathname'
    
    def initialize(root = Project::root)
      @libraries = []
      @root = root
    end

    SCRIPT_ECIC = File.join('src',  'config', 'ecic.rb')
    LIBRARIES_CFG_SCRIPT = File.join('src',  'config', 'libraries.rb')
    
    #Function that returns the root directory of a ECIC project
    def self.root(path = Pathname.new(Dir.pwd))
      if File.exists?(File.join(path, SCRIPT_ECIC))
        return path
      elsif path.root?
        return nil
      end
      return root(path.parent)
    end

    def default_library_cfg_file
      File.join(@root, LIBRARIES_CFG_SCRIPT)
    end

    
    def load_libraries(lib_file = default_library_cfg_file)
      if File.exists?(lib_file)
#        puts "Reading #{lib_file}"
        eval File.read(lib_file)
      else
        raise "Could not read library definitions from #{lib_file}"
      end

    end

    def add_libray(name)
      @libraries << Library.new(name)
    end

    def library
      new_lib = Library.new()
      libraries << new_lib
      new_lib
    end

  end
end