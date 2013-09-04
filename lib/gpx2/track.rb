module GPX2
  class Track
    attr_accessor :name
    attr_accessor :comment
    attr_accessor :description
    attr_accessor :source
    attr_accessor :number
    attr_accessor :extensions

    attr_reader :segments
    attr_reader :links

    def initialize
      @segments = []
      @links = []
    end
  end
end
