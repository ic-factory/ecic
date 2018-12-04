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
      copy_file 'config/ecic.rb', 'src/config/ecic.rb'
      @ruby_version = '2.4.4'
      template("Gemfile.tt","Gemfile")
    end

    def create_output_directories
      empty_directory 'src/design'
      create_file 'src/design/.gitkeep' if Dir.empty?("#{destination_root}/src/design")
      empty_directory 'src/testbench'
      create_file 'src/testbench/.gitkeep' if Dir.empty?("#{destination_root}/src/testbench")
      empty_directory 'src/external_packages'
      create_file 'src/external_packages/.gitkeep' if Dir.empty?("#{destination_root}/src/external_packages")
      empty_directory 'src/docs'
      create_file 'src/docs/.gitkeep' if Dir.empty?("#{destination_root}/src/docs")
    end

    def git_init
      run 'git init ' + destination_root
    end
  end

end
