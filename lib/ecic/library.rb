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
      @path = opt[:path] || default_path
      @source_files = []
      @sources_have_been_loaded = false
    end

    def default_path
      paths = {:testbench => "src/testbench/#{@name}",
               :design    => "src/design/#{@name}"}
      paths[@type]
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

    def sources_have_been_loaded?
      return @sources_have_been_loaded
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
      src_file = File.join(absolute_path, 'sources.rb')
      if File.exists?(src_file)
        begin
          @sources_have_been_loaded = true
#          puts "\#Reading #{src_file} ..."
          eval File.read(src_file)
        rescue Exception => exc
          raise "Syntax error occurred while reading #{src_file}: #{exc.message}"
        end
      else
        raise "Could not read sources for #{name} library. #{src_file} file does not exist"
      end
    end

    def is_a_testbench?
      @type == :testbench
    end



    #Function used in sources.rb file of each library
    def source_file(path, options={})
      opt = {:scope => nil}.merge(options)
#      puts "test1"
      if has_source_file?(path)
#        puts "#{path} already exists"
        src_file = get_src_file(path)
#        p opt[:scope]
        opt[:scope].to_a.each do |s|
          src_file.add_scope(s)
        end
#p src_file.scopes
      else
#        puts "Creating new source file: #{path}"
        src_file = SourceFile.new(self, path, options)
        source_files << src_file
      end
      src_file
    end

    #Function to return the absolute path to the library.
    # (Note: The @path variable may or may not contain an absolute path)
    def absolute_path
      Pathname.new(@path).absolute? ? @path : File.expand_path("#{@project.root}/#{@path}")
    end

    ###########################################################################
    protected
    ###########################################################################

    def validate_name
      raise "#{@name} is not a valid library name. Library names must start with a letter, followed by one or more numbers, letters or underscores" unless /\A[a-zA-Z]\w*\Z/.match(@name)
    end

    def validate_type
      raise "Library type must be either 'design' (default) or 'tb' (=testbench)" unless [:design, :testbench].include?(@type)
    end

    def get_src_file(path)
#      puts "searching for #{path} match ..."
      matching_files = source_files.select {|s| s.path.eql? path }
      raise "Found multiple source files with path '#{path}'" if matching_files.length > 1
      matching_files.first
    end

    ###########################################################################
    private
    ###########################################################################

    def validate
      validate_name
      validate_type
    end


    def has_source_file?(path)
      source_files.any? {|s| s.path.eql? path}
    end


  end
end
