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

  def library_creation_cmd(library)
    case library.path.to_s
    when "src/design/#{library.name}"
      cmd = "design_library('#{library.name}'"
    when "src/testbench/#{library.name}"
      cmd = "testbench_library('#{library.name}'"
    else
      if library.is_a_testbench?
        cmd = "testbench_library('#{library.name}'"
      else
        cmd = "design_library('#{library.name}'"
      end
      cmd += ", :path => '#{library.path}'"
    end
    unless library.scopes.nil?
      cmd += ", :scope => " + library.scopes.to_s
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

end
