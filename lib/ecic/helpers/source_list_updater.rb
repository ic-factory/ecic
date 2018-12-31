module Ecic::SourceListUpdater
  def add_src_file(src_file_info, dest_root)
    #If the absolute_file_path is outside the project folder, the absolute
    #file path must be used instead of 'relative_file_path'
    src_list_filepath = dest_root.join(src_file_info.sources_file_path)
    absolute_file_path = src_file_info.absolute_path
    if src_file_info.is_outside_project?
      used_file_ref = absolute_file_path.to_s
    else
      used_file_ref = absolute_file_path.relative_path_from(dest_root.join(src_list_filepath.dirname)).to_s
    end
    create_file src_list_filepath unless File.exists?(src_list_filepath)
    #Get existing source file or add a new one to the library, if no matching source file exists:
    src_file = src_file_info.library.source_file(used_file_ref, :scope => src_file_info.scopes)
    match_pattern = "source_file\\(\'#{src_file.path}\'"
    file_content = File.read(src_list_filepath)
    new_file_content = file_content.gsub(/(#{match_pattern}.+)/, src_file_text(src_file))
    unless $1
      #No match was found, so just add a new line to the sources.rb file:
      append_to_file src_list_filepath, src_file_text(src_file) + "\n"
    else
      #A match was found, so write the updated content to the file:
      File.open(src_list_filepath, "w") {|file| file.puts new_file_content }
    end
  end

  private

  def src_file_text(src_file)
    text = "source_file('#{src_file.path}'"
    unless src_file.scopes.nil?
      text += ", :scope => " + src_file.scopes.to_s
    end
    text += ")"
  end



end
