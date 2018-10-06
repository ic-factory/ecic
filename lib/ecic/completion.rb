module Ecic
  class Completion < Command
    desc "script", "generates script that can be eval to setup auto-completion"
    long_desc Help.text('completion')['script']['long']
    def script
      Completer::Script.generate
    end

    desc "completions *PARAMS", "prints words for auto-completion"
    long_desc Help.text('completion')['list']['long']
    def list(*params)
      Completer.new(*params).run
    end
  end
end
