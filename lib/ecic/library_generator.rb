module Ecic

  class LibraryGenerator < Thor::Group
    include Thor::Actions
    include Ecic::LibraryCreationHelper
    desc 'Generate a new RTL library'

    attr_writer :library

    def self.source_root
      File.dirname(__FILE__) + '/../../templates/project'
    end

    def create_library_directory
      src_list_file = "#{@library.absolute_path}/sources.rb"
      template("src/design/lib/sources.rb.tt", src_list_file) unless File.exist?(src_list_file)
    end

    def add_library_to_library_list
      libraries_file = File.expand_path("#{destination_root}/src/config/libraries.rb")
      empty_directory 'src/config' unless File.exist?(File.dirname(libraries_file))
      create_file libraries_file unless File.exist?(libraries_file)
      cmd = library_creation_cmd(@library)
      append_to_file 'src/config/libraries.rb', cmd
    end

  end

end
