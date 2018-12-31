module Ecic
  class FileAdder < Thor::Group
    include Thor::Actions
    include Ecic::SourceListUpdater
    include Ecic::LibraryCreationHelper
    require 'pathname'

    attr_accessor :library_name, :file_names, :project, :force_library_creation, :scope

    def add_files_to_source_list
      #If a library name is given, the project must already contain a library
      #with that name. Otherwise an error message must be returned, because we
      #do not know if it is a design or testbench library.
      unless library_name.nil?
        library = project.get_library(library_name)
        if library.nil?
          #Library does not already exist
          if force_library_creation
            library = project.library(library_name, :design)
            generate_library library
          else
            raise "Unknown library '#{library_name}'. Please generate the library before adding files to it or use -f option to force the creation of it."
          end
        end
      end
      destination_path = Pathname.new(destination_root)
      file_names.each { |file_name|
        src_file_info = SourceFileInfo.new(project, file_name, library, scope)
        raise "Library name could not be determined from the path of '#{file_name}'.\nIf the library already exists, please specify the library name with the --lib option when adding files to it.\nTo create a new library, run 'ecic generate library' command - or create an empty sources.rb file in the root directory of the library." if src_file_info.library.nil?
        if create_library_if_missing(src_file_info.library)
          #Load the list of source files for th given library, unless the list of sources has already been loaded once.
          src_file_info.library.load_sources unless src_file_info.library.sources_have_been_loaded?
          add_src_file(src_file_info, destination_path)
        else
          say set_color("Skipping #{file_name}",Thor::Shell::Color::BLUE)
        end
      }
    end
  end
end
