module GPX2
  class Segment
    attr_reader :trackpoints
    attr_accessor :extensions

    def initialize
      @trackpoints = []
    end
  end
end
