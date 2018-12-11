module Ecic

  class LibraryGenerator < Thor::Group
    include Thor::Actions
    desc 'Generate a new RTL library'

    attr_writer :library

    def self.source_root
      File.dirname(__FILE__) + '/../../templates/project'
    end

    def create_library_directory
      @library_name = @library.name
      src_list_file = File.expand_path("#{destination_root}/#{@library.path}/sources.rb")
      template("src/design/lib/sources.rb.tt", src_list_file) unless File.exist?(src_list_file)
    end

    def update_library_list
      libraries_file = File.expand_path("#{destination_root}/src/config/libraries.rb")
      empty_directory 'src/config' unless File.exist?(File.dirname(libraries_file))
      create_file libraries_file unless File.exist?(libraries_file)
      case @library.path.to_s
      when "src/design/#{@library.name}"
        cmd = "design_library('#{@library.name}')"
      when "src/testbench/#{@library.name}"
        cmd = "testbench_library('#{@library.name}')"
      else
        if @library.is_a_testbench?
          cmd = "testbench_library('#{@library.name}', :path => '#{@library.path}')"
        else
          cmd = "design_library('#{@library.name}', :path => '#{@library.path}')"
        end
      end
      append_to_file 'src/config/libraries.rb', "#{cmd}.create\n"
    end

  end

end
