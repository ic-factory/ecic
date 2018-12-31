module Ecic

  class SourceFile

    attr_accessor :path #, :library

    def initialize(library, path, options={})
      opt = {:scope => nil}.merge(options)
      @library = library
      @path = path
      @scopes = Set.new
      opt[:scope].to_a.each do |s|
        @scopes.add(s)
      end
    end

    def to_s
      "#{path}"
    end

    def scopes
      @scopes.to_a.sort
    end

    # def has_scope?(scope)
    #   @scopes.include? scope
    # end

    def add_scope(scope)
#      puts "Adding #{scope} scope to #{self.path}"
      @scopes.add(scope)
    end

  end
end
