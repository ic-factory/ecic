module Ecic

  class SvDesignGenerator < Thor::Group
    include Thor::Actions
    desc 'Generate a new SystemVerilog design'

    attr_writer :library_name, :design_name
    
    def self.source_root
      File.dirname(__FILE__) + '/../../templates/project'
    end

    def copy_rtl_templates
      base_name = "src/design/#{@library_name}/#{@design_name}"
      template("src/design/lib/design.sv.tt", "#{base_name}.sv")
    end

    def update_src_list
      src_file = "src/design/#{@library_name}/sources.rb"
      create_file src_file unless File.exists?(src_file)
      append_to_file src_file, "source_file.create('#{@design_name}.sv')\n"
    end
  end

end