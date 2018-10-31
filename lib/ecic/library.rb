module Ecic

  class Library

    attr_accessor :name, :path, :project
    attr_accessor :source_files
    attr_reader   :type

    
    def initialize(project, name, type, options={})
      opt = {:path => nil}.merge(options)
      @project = project
      @type = type
      @name = name
      default_path = {:testbench => "src/testbench/#{@name}",
                      :design    => "src/design/#{@name}"}
      @path = opt[:path] || default_path[@type]
      @source_files = []
    end
    
    def is_valid?
      begin
        validate_name
        return false if already_exists?
        #TBA: validate unique name as well
        return true
        #TBA: 'validate_name' should raise a specific naming exception and only this specific exception should be caught. 
      rescue Exception => exc
        return false
      end
    end
    
    def create
      validate_name
      @project.add_library self      
    end

    def already_exists?
      @project.has_library?(self)
    end

    def to_str(options={})
      to_s(options)
    end
    
    def to_s(options={})
      str = name
      incl_src_files = options[:include_source_files] || false
      if incl_src_files
        str += ":"
        str += "\n  " + source_files.join("\n  ") unless source_files.length == 0
      end
      str
    end

    def to_json(options = {})
      incl_src_files = options[:include_source_files] || false
      hash = {:name => name, :path => path}
      hash[:source_files] = source_files if incl_src_files
      hash.to_json
    end

    def load_sources
      src_file = File.join(@project.root, @path, 'sources.rb')
      if File.exists?(src_file)
        begin
          puts "reading #{src_file} ..."
          eval File.read(src_file)
        rescue Exception => exc
          raise "Syntax error occurred while reading #{src_file}: #{exc.message}"
        end
      else
#        p @path
#        p @type
        raise "Could not read sources for #{name} library. #{src_file} file does not exist"
      end
    end

    def is_a_testbench?
      @type == :testbench
    end
    
    #Function used in sources.rb file of each library
    def source_file(path)
#      puts "Creating new source file"
      new_src = SourceFile.new(self, path)
      source_files << new_src
      new_src
    end

    ###########################################################################    
    protected
    ###########################################################################    

    def validate_name
      raise "#{@name} is not a valid library name. Library names must start with a letter, followed by one or more numbers, letters or underscores" unless /\A[a-zA-Z]\w*\Z/.match(@name)
    end
    
  end
end