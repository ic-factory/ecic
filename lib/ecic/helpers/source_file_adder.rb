module Ecic::SourceFileAdder
  def add_src_file(file_name)
    src_file = "src/design/#{@library_name}/sources.rb"
    create_file src_file unless File.exists?(src_file)
    append_to_file src_file, "source_file.create('#{file_name}')\n"
  end
end