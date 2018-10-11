module Ecic

  class DesignGenerator < Thor::Group
    include Thor::Actions
    desc 'Generate a new RTL design'

    attr_writer :library_name, :design_name
    
    def self.source_root
      File.dirname(__FILE__) + '/../../templates/project'
    end


#    def initialize(project_root_path, lib_name)
#      @destination_root = project_root_path
#      @library_name = lib_name
#    end
    
#    def create_design_directory
#      empty_directory "src/design/#{@library_name}/#{File.dirname(@design_name)}"
#    end

    def update_src_list
      template("src/design/lib/pkg_types.vhd.tt", "src/design/#{@library_name}/#{@design_name}-pkg_types.vhd")
      template("src/design/lib/pkg_comp.vhd.tt", "src/design/#{@library_name}/#{@design_name}-pkg_comp.vhd")
      template("src/design/lib/ent.vhd.tt", "src/design/#{@library_name}/#{@design_name}-ent.vhd")
      template("src/design/lib/arc_rtl.vhd.tt", "src/design/#{@library_name}/#{@design_name}-arc_rtl.vhd")
    end

  end

end