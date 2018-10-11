module Ecic

  class Library

    attr_accessor :name

    def initialize(name=nil)
      @name = name
    end

    def create(name)
      @name = name      
    end
    
    def to_s
      @name
    end

  end
end