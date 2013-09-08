require "nokogiri"
require "gpx2/parser"

module GPX2
  class Document
    attr_accessor :version
    attr_accessor :creator
    attr_accessor :metadata
    attr_reader :tracks

    def self.parse(file)
      new.tap { |doc| doc.parse(file) }
    end

    def self.parse_file(file)
      parse(File.open(file))
    end

    def initialize
      @tracks = []
    end

    def parse(data)
      parser = Nokogiri::XML::SAX::Parser.new(Parser.new(self))
      parser.parse(data)
    end

    def parse_file(file)
      parse(File.open(file))
    end
  end
end
