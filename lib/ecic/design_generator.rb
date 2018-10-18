module Ecic

  class DesignGenerator < Thor::Group
#    require source_file_adder
    include Thor::Actions
    include Ecic::SourceFileAdder

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
      base_name = "src/design/#{@library_name}/#{@design_name}"
      @include_types_pkg ||= false
      if @include_types_pkg
        template("src/design/lib/pkg_types.vhd.tt", "#{base_name}-pkg_types.vhd")
      end
      template("src/design/lib/pkg_comp.vhd.tt", "#{base_name}-pkg_comp.vhd")
      template("src/design/lib/ent.vhd.tt", "#{base_name}-ent.vhd")
      template("src/design/lib/arc_rtl.vhd.tt", "#{base_name}-arc_rtl.vhd")
    end

    def update_src_list
      src_file = "src/design/#{@library_name}/sources.rb"
      create_file src_file unless File.exists?(src_file)
      @include_types_pkg ||= false
      if @include_types_pkg
        add_src_file("#{@design_name}-pkg_types.vhd")
      end
      add_src_file("#{@design_name}-pkg_comp.vhd")
      add_src_file("#{@design_name}-ent.vhd")
      add_src_file("#{@design_name}-arc_rtl.vhd")
    end

  end

end