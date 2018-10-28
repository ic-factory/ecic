module Ecic

  class Library

    attr_accessor :name, :path, :project
    attr_accessor :source_files
    attr_reader   :type

    
    def initialize(project, type, options={})
      defaults = {:name => nil,
                  :path => nil}
      opt = defaults.merge(options)
      @project = project
      @type = type
      @name = opt[:name]
      default_path = {:testbench => "src/testbench/#{@name}",
                      :design    => "src/design/#{@name}"}
      @path = opt[:path] || default_path[@type]
#      puts @path
      @source_files = []
    end

    def create(name, options = {})
      opt = {:path => @path}.merge(options)
      @name = name
      #By default the @path remains unchanged - unless it is nil, in which case 
      #it will be set to a default value according to the type:
      default_path = {:testbench => "src/testbench/#{@name}",
                      :design    => "src/design/#{@name}"}
      @path = opt[:path] || default_path[@type]
      save
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
    
    def save
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
#          puts "reading #{src_file} ..."
          eval File.read(src_file)
        rescue Exception => exc
          raise "Syntax error occurred while reading #{src_file}: #{exc.message}"
        end
      else
#        p @path
#        p @type
        raise "Could not read sources for #{name} library"
      end
    end

    def is_a_testbench?
      @type == :testbench
    end
    
    #Function used by 'source.create' method used in src/confic/libraries.rb
    def source_file
#      puts "Creating new source file"
      new_src = SourceFile.new(self)
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