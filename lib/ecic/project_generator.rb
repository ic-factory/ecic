module Ecic

  class ProjectGenerator < Thor::Group
    include Thor::Actions
    desc 'Generate a new chip project'
  
    def self.source_root
      File.dirname(__FILE__) + '/../../templates/project'
    end

    def create_base_files
      copy_file 'gitignore', '.gitignore'
      copy_file 'config/project.rb', 'src/config/project.rb'
      copy_file 'config/libraries.rb', 'src/config/libraries.rb'
      copy_file 'Gemfile', 'Gemfile'
    end

    def create_output_directories
      #TBA: Replace these lines with a call to a TestbenchGenerator class
      empty_directory 'src/testbench/chip'
      empty_directory 'src/verification/chip'

      copy_file 'src/packages/README.txt', 'src/packages/README.txt'
      create_file 'src/design/chip/sources.rb'
      empty_directory 'src/external_packages'
    end

    #Replace this function with a call to a 'VHDLComponentGenerator' class
    def create_top_entity
      create_file 'src/design/chip/sources.yaml.erb'
      create_file 'src/design/chip/chip-rtl_arc.vhd'
      create_file 'src/design/chip/chip-ent.vhd'
    end

    def git_init
      run 'git init ' + destination_root
    end
  end

end