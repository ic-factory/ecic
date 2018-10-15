module Ecic

  class DesignGenerator < Thor::Group
    include Thor::Actions
    desc 'Generate a new RTL design'

    attr_writer :library_name, :design_name, :include_types_pkg
    
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

    def copy_rtl_templates
      @include_types_pkg ||= false
      if @include_types_pkg
        template("src/design/lib/pkg_types.vhd.tt", "src/design/#{@library_name}/#{@design_name}-pkg_types.vhd")
      end
      template("src/design/lib/pkg_comp.vhd.tt", "src/design/#{@library_name}/#{@design_name}-pkg_comp.vhd")
      template("src/design/lib/ent.vhd.tt", "src/design/#{@library_name}/#{@design_name}-ent.vhd")
      template("src/design/lib/arc_rtl.vhd.tt", "src/design/#{@library_name}/#{@design_name}-arc_rtl.vhd")
    end

    def update_src_list
      @include_types_pkg ||= false
      if @include_types_pkg
        append_to_file "src/design/#{@library_name}/sources.rb", "\nsource.create('#{@design_name}-pkg_types.vhd')"
      end
      append_to_file "src/design/#{@library_name}/sources.rb", "\nsource.create('#{@design_name}-pkg_comp.vhd')"
      append_to_file "src/design/#{@library_name}/sources.rb", "\nsource.create('#{@design_name}-ent.vhd')"
      append_to_file "src/design/#{@library_name}/sources.rb", "\nsource.create('#{@design_name}-arc_rtl.vhd')\n"
    end
  end

end