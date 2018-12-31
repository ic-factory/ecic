module Ecic
  #Class that can provide various info about what do to with a source file.
  class SourceFileInfo

    require 'pathname'

    attr_reader :absolute_path, :library

    STANDARD_LIBRARY_FOLDERS_LIST = ["src/design", "src/testbench"]

    def initialize(project, file_name, library=nil, scope=nil)
      @project = project
      @absolute_path = Pathname.new(File.expand_path(file_name))
      @relative_path_from_project = @absolute_path.relative_path_from(Pathname.new("#{@project.root}"))
      @library = library || get_library_from_file_path
      @scope = scope
      @scopes = Set.new
      scope.each do |s|
        @scopes.add(s)
      end

    end

    #TBA: Make sure this function works for libraries under src/testbench as
    #well and make sure it returns nil, if the library name cannot be determined.
    #TBA: Update this function to first look for any sources.rb files within the
    #project folder structure.
    def get_library_from_file_path
      return nil if is_outside_project?
      sources_file_dir = find_sources_file_dir
      if sources_file_dir
        #A sources.rb file was found."
        #Check if an existing library is already mapped to that folder. If so, return that library
        #and otherwise return a new library that is named according to the  folder
        already_mapped_lib = @project.library_mapped_to(sources_file_dir.to_s)
        return already_mapped_lib if already_mapped_lib
        #Use the name of the folder as the library name:"
        lib_dir = sources_file_dir
      else
#        puts "        #Could not find an existing sources.rb file for the given source file"
        lib_dir = get_default_library_dir_from_file_path
      end
      unless lib_dir.nil?
        lib_name = lib_dir.basename.to_s
        Ecic::Library.new(@project, lib_name, get_library_type_from_file_path, :path => lib_dir)
      end
    end

    def is_outside_project?
#      @relative_path_from_project.to_s.split('/')[0] == ".."
      /\A\.\./.match(@relative_path_from_project.to_s)
    end

#    def within_expected_folder?
#      rel_design_path_list = @relative_path_from_project.to_s.split('/')
#      return nil if rel_design_path_list.length < 3
#      str = [rel_design_path_list.first(2)].join('/')
#      STANDARD_LIBRARY_FOLDERS_LIST.include? str
#    end

    #Function that looks for a sources.rb file within the project
    def find_sources_file_dir(dir = @relative_path_from_project.dirname)
      return nil if is_outside_project?
      file = File.join(@project.root, dir, "sources.rb")
      if dir.root? or dir.to_s == "."
        return nil
      elsif File.exists?(file)
        return dir
      else
        return find_sources_file_dir(dir.parent)
      end
    end

    #Function that returns the name of the directory that is placed just under src/design or src/testbench:
    def get_default_library_dir_from_file_path
      #Get the first directory name after src/design or src/testbench:
      rel_design_path_list = @relative_path_from_project.to_s.split('/')
      return nil if rel_design_path_list.length < 3
      return nil unless STANDARD_LIBRARY_FOLDERS_LIST.include? [rel_design_path_list.first(2)].join('/')
      Pathname.new([rel_design_path_list.first(3)].join('/'))
    end

    #Function that returns the type of library that
    def get_library_type_from_file_path
      #Get the first directory name after src/design or src/testbench:
      rel_design_path_list = @relative_path_from_project.to_s.split('/')
      return nil if rel_design_path_list.length < 2
      case [rel_design_path_list.first(2)].join('/')
      when "src/testbench"
        return :tb
      when "src/design"
        return :design
      else
        return :design
      end
    end

    def sources_file_path
      return nil if @library.nil?
#      puts "#{@library.path}/sources.rb"
      Pathname.new("#{@library.path}/sources.rb")
    end

    def scopes
      @scopes.to_a.sort
    end

  end
end
