module Ecic::Help
  require 'yaml'
  class << self
    def text(namespaced_command)
      hlp = YAML.load(File.read(File.expand_path("../../../config/locales/help.en.yaml", __FILE__)))['help'][namespaced_command]
#      hlp['short']
    end
    def long(namespaced_command)
      p namespaced_command
      hlp = YAML.load(File.read(File.expand_path("../../../config/locales/help.en.yaml", __FILE__)))['help'][namespaced_command]
#      hlp['long']
    end
  end
end
