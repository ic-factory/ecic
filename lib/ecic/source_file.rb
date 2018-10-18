module Ecic

  class SourceFile

    attr_accessor :path #, :library

    def initialize(library)
      @library = library
    end

    def create(path)
      @path = path      
    end

    def to_s
      "#{path}"
    end

  end
end