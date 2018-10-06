module Ecic::Help
  class << self
    def text(namespaced_command)
      path = namespaced_command.to_s.gsub(':','/')
      path = File.expand_path("../help/#{path}.md", __FILE__)
      IO.read(path) if File.exist?(path)
    end
    def short_text(namespaced_command)
      path = namespaced_command.to_s.gsub(':','/')
      path = File.expand_path("../help/#{path}_short.md", __FILE__)
      IO.read(path) if File.exist?(path)
    end
  end
end
