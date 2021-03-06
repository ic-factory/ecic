#TBA:
# 1. Create a generator that creates a new (custom) generator
# 2. Add project name and version as options to 'new' generator
# 3. Add option to specify whether separate files must be used (by default) for VHDL entities
#    and architectures.
# 4. Make sure the 'new' action calls 'bundle install' in new project.
# 5. What should the file format be for libraries and source file config files? We want 
#    to be able to automatically add content to these files.
#        sources.yaml
#        sources.yaml.erb
#        sources.rb <- This might be the best option (and have a convention for what it should contain).
#        libraries.rb <- This might be the best option.
# If the user tries to call the 'generate' command outside a project, 
# an error message must be returned stating that this command can only be called from within a project.

$:.unshift(File.expand_path("../", __FILE__))
require "ecic/version"

module Ecic
  autoload :Help, "ecic/help"
  autoload :Command, "ecic/command"
  autoload :CLI, "ecic/cli"
  autoload :Generate, "ecic/generate"
  autoload :FileAdder, "ecic/file_adder"
  autoload :Completion, "ecic/completion"
  autoload :Completer, "ecic/completer"
  autoload :ProjectCmd, "ecic/project_cmd"
  autoload :DesignGenerator, "ecic/design_generator"
  autoload :SvDesignGenerator, "ecic/sv_design_generator"
  autoload :ProjectGenerator, "ecic/project_generator"
  autoload :LibraryGenerator, "ecic/library_generator"
  autoload :SourceListUpdater, "ecic/helpers/source_list_updater"
  autoload :LibraryCreationHelper, "ecic/helpers/library_creation_helper"
  autoload :SourceFile, "ecic/source_file"
  autoload :Library, "ecic/library"
  autoload :Project, "ecic/project"
  autoload :SourceFileInfo, "ecic/source_file_info"
end