module Ecic

  class SourceFile

    attr_accessor :path #, :library

    def initialize(library, path)
      @library = library
      @path = path
    end

    def to_s
      "#{path}"
    end

  end
end