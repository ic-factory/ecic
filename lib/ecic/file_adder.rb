module Ecic
  class FileAdder < Thor::Group
    include Thor::Actions
    include Ecic::SourceListUpdater
    include Ecic::LibraryCreationHelper
    require 'pathname'

    attr_accessor :library_name, :file_names, :project

    def add_files_to_source_list
      #If a library name is given, the project must already contain a library
      #with that name. Otherwise an error message must be returned, because we
      #do not know if it is a design or testbench library.
      unless library_name.nil?
        library = project.get_library(library_name)
        raise "Unknown library called '#{library_name}'. Please create the library before adding files to it. " if library.nil?
      end
      destination_path = Pathname.new(destination_root)      
      file_names.each { |file_name|
        src_file_info = SourceFileInfo.new(project, file_name, library)
        raise "Library name could not be determined from the path of '#{file_name}'.\nMake sure the appropriate library has been created and specify it with the --lib option - or create an empty sources.rb file in the root directory of the library." if src_file_info.library.nil?
        if create_library_if_missing(src_file_info.library)
          add_src_file(src_file_info, destination_path)
        else
          say set_color("Skipping #{file_name}",Thor::Shell::Color::BLUE)
        end
      }
    end
  end
end