module Ecic

  #Class to update the library definition in a src/config/libraries.rb file:
  class LibraryListUpdater < Thor::Group
    include Thor::Actions
    include Ecic::LibraryCreationHelper
    desc 'Updates the definition of a library in a library list file'

    attr_writer :library

    def update
      libraries_file = File.expand_path("#{destination_root}/src/config/libraries.rb")
      cmd = library_creation_cmd(@library)

      match_start = @library.is_a_testbench? ? 'testbench_library' : 'design_library'
      lib_filename = 'src/config/libraries.rb'
#      if @library.is_a_testbench?
        gsub_file lib_filename, /#{match_start}\(\'#{@library.name}\'.+/, cmd
#      else
#        gsub_file lib_filename, /design_library\(\'#{@library.name}\'.+/, cmd
#      end
    end

  end

end