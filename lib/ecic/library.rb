module Ecic

  class Library

    require 'set'

    attr_accessor :name, :path, :project
    attr_accessor :source_files
    attr_reader   :type

    def initialize(project, name, type, options={})
      opt = {:path => nil, :scope => nil}.merge(options)
      @project = project
      @scopes = Set.new
      opt[:scope].to_a.each do |s|
        @scopes.add(s)
      end
      @name = name
      @type = type
      default_path = {:tb      => "src/testbench/#{@name}",
                      :design  => "src/design/#{@name}"}
      @path = opt[:path] || default_path[@type]
      @source_files = []
    end

    def has_scope?(scope)
      @scopes.include? scope
    end

    def add_scope(scope)
      @scopes.add(scope)
    end

    def scopes
      @scopes.to_a.sort
    end

    def create
      validate
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
          #puts "\#Reading #{src_file} ..."
          eval File.read(src_file)
        rescue Exception => exc
          raise "Syntax error occurred while reading #{src_file}: #{exc.message}"
        end
      else
        raise "Could not read sources for #{name} library. #{src_file} file does not exist"
      end
    end

    def is_a_testbench?
      @type == :tb
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

    def validate_type
      raise "Library type must be either 'design' (default) or 'tb' (=testbench)" unless [:design, :tb].include?(@type)
    end


    ###########################################################################
    private
    ###########################################################################

    def validate
      validate_name
      validate_type
    end

  end
end
