module Ecic::SourceListUpdater
  def add_src_file(src_file_info, dest_root)
    #TBA: IF THE absolute_file_path IS OUTSIDE THE PROJECT FOLDER, THEN THE ABSOLUTE FILE PATH MUST BE USED INSTEAD OF 'relative_file_path'
    src_list_filepath = src_file_info.sources_file_path
    absolute_file_path = src_file_info.absolute_path
#    puts "src_list_filepath=#{src_list_filepath}"
#    puts "absolute_file_path=#{absolute_file_path}"
#    puts "dest_root=#{dest_root}"
    if src_file_info.is_outside_project?
      used_file_ref = absolute_file_path.to_s
    else
      used_file_ref = absolute_file_path.relative_path_from(dest_root.join(src_list_filepath.dirname)).to_s
    end
#        puts "relative_file_path = #{relative_file_path}"
#        relative_src_list_filepath = src_list_filepath.relative_path_from(dest_root).to_s
#    puts "relative_src_list_filepath = relative_src_list_filepath"
#    src_file = "src/design/#{library_name}/sources.rb.tfj"
    create_file src_list_filepath unless File.exists?(File.join(dest_root,src_list_filepath))
    append_to_file src_list_filepath, "source_file.create('#{used_file_ref}')\n"
  end
end