module Ecic

  class FileAdder < Thor::Group
    include Thor::Actions
    include Ecic::SourceFileAdder

    attr_writer :library_name, :file_names
    
#    def self.source_root
#      File.dirname(__FILE__) + '/../../templates/project'
#    end

    def add_files_to_source_list
      @file_names.each { |file_name|
        add_src_file(file_name)
      }
    end

  end

end