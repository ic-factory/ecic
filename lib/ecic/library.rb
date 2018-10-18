module Ecic

  class Library

    attr_accessor :name
    attr_accessor :source_files

    def initialize(project, name=nil)
      @project = project
      @name = name
      @source_files = []
    end

    def create(name)
      @name = name      
    end
    
    def to_str(options={})
      str = name
      incl_src_files = options[:include_source_files] || false
      if incl_src_files
        str += "\n" + source_files.join("\n") 
      end
      str
    end

    def to_json(options = {})
      incl_src_files = options[:include_source_files] || false
      if incl_src_files
        str = {:name => name, :source_files => source_files}.to_json
      else
        str = {:name => name}.to_json        
      end
    end

    def load_sources
      src_file = File.join(@project.root, 'src', 'design', @name, 'sources.rb')
      if File.exists?(src_file)
        begin
          eval File.read(src_file)
        rescue Exception => exc
          raise "Syntax error occurred while reading #{src_file}: #{exc.message}"
        end
      else
        raise "Could not read sources for #{name} library"
      end
    end

    #Function used by 'source.create' method used in src/confic/libraries.rb
    def source_file
      new_src = SourceFile.new(self)
      source_files << new_src
      new_src
    end

  end
end