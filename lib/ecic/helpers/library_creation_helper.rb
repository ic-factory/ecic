module Ecic::LibraryCreationHelper
  
  def create_library_if_missing(library)
    unless library.already_exists?
      return ok_to_create_library? library
    end
    return true
  end

  def ok_to_create_library?(library)
    if must_create_new_library? library
      return generate_library library
    end
#    shell.error set_color("Operation aborted!",Thor::Shell::Color::RED)
#    exit(2)
    return false
  end
  
  def generate_library(library)
    if library.is_valid?
      generator = Ecic::LibraryGenerator.new
      generator.destination_root = library.project.root
      generator.library = library
      generator.invoke_all
      library.create
    else
      return false
    end
  end

  protected
  
  def must_create_new_library?(library)
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
      when is?(:yes), is?(:all), ""
        return true
      when is?(:no), is?(:skip)
        return false
      when is?(:always)
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
  
end