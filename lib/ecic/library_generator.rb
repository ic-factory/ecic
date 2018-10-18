module Ecic

  class LibraryGenerator < Thor::Group
    include Thor::Actions
    desc 'Generate a new RTL library'

    attr_writer :library_name
    
    def self.source_root
      File.dirname(__FILE__) + '/../../templates/project'
    end

    def create_library_directory
      template("src/design/lib/sources.rb.tt", "src/design/#{@library_name}/sources.rb")
    end

    def update_library_list
      libraries_file = File.expand_path("#{destination_root}/src/config/libraries.rb")
      empty_directory 'src/config' unless File.exist?(File.dirname(libraries_file))      
      create_file libraries_file unless File.exist?(libraries_file)                  
      append_to_file 'src/config/libraries.rb', "library.create('#{@library_name}')\n"
    end

  end

end