module Ecic::LibraryCreationHelper

  def create_library_if_missing(library)
    return true if library.already_exists?
    ok_to_create_library? library
  end

  def ok_to_create_library?(library)
    return false unless user_accepts_library_creation? library
    generate_library library
  end

  def generate_library(library)
    library.create
    generator = Ecic::LibraryGenerator.new
    generator.destination_root = library.project.root
    generator.library = library
    generator.invoke_all
  end

  #Function that returns the string that must be added to a libraries.rb file
  #when adding/creating a new library.
  def library_creation_cmd(library)
    cmd = "#{library.type.to_s}_library('#{library.name}'"
    unless path_maps_to_default_path?(library)
      cmd += ", :path => '#{library.path}'"
    end
    if library.scopes.any?
      cmd += ", :scope => #{library.scopes.to_s}"
    end
    cmd += ").create\n"
  end

  protected

  def user_accepts_library_creation?(library)
    return true if @always_create_library
    options = "[Ynaqh]"
    loop do
      answer = ask(
        %[#{library.type.to_s.capitalize} library '#{library.name}' does not exist. Create it? (enter "h" for help) #{options}],
        :add_to_history => false
      )
      case answer
      when nil
        say ""
        return true
      when is?(:yes), ""
        return true
      when is?(:no), is?(:skip)
        return false
      when is?(:all)
        return @always_create_library = true
      when is?(:quit)
        say "Aborting..."
        raise SystemExit
      else
        say library_creation_help
      end
    end
  end

  def library_creation_help
    puts "        Y - yes, create the library (default)"
    puts "        n - no, continue without creating the library"
    puts "        a - all, create this library (and any other)"
    puts "        q - quit, abort"
    puts "        h - help, show this help"
  end

  def is?(value) #:nodoc:
    value = value.to_s
    if value.size == 1
      /\A#{value}\z/i
    else
      /\A(#{value}|#{value[0, 1]})\z/i
    end
  end

  private

    #The path to a library must be the path relative to the project, unless
    #the library is placed outside the project (in which case the absolute path
    #must be used)
    def resolved_path(root, path)
      return nil if path.nil?
      absolute_path = Pathname.new(File.expand_path(path))
      relative_path_from_project = absolute_path.relative_path_from(Pathname.new(root))
      #If the path is outside the project, return the absolute path and
      #otherwise return the path relative to the project.
      /\A\.\./.match(relative_path_from_project.to_s) ? absolute_path : relative_path_from_project
    end

    def path_maps_to_default_path?(library)
      library.path == library.default_path
    end

end
