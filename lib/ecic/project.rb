module Ecic

  class Project

    require 'pathname'

    SCRIPT_ECIC = File.join('config', 'ecic.rb')

    #Function that returns the root directory of a ECIC project
    def self.root(path = Pathname.new(Dir.pwd))
      if File.exists?(File.join(path, SCRIPT_ECIC))
        return path
      elsif path.root?
        return nil
      end
      return root(path.parent)
    end

  end
end