require "nokogiri"

module GPX2
  class ParseError < StandardError
  end

  class Parser < Nokogiri::XML::SAX::Document
    def initialize(doc)
      @doc      = doc
      @pedantic = true
      @nodes    = []
      @stack    = []
    end

    private

    def pedantic?
      @pedantic == true
    end

    def pedantic(message)
      error(message) if pedantic?
    end

    def error(message)
      raise ParseError, message
    end

    def attr_value(attrs, name)
      attrs.find { |n, _| n == name }[1]
    end

    def start_element(name, attrs = [])
      @nodes << name
      @buffer = ""

      push_state = nil

      case @stack
      when []
        case name
        when "gpx"
          @doc.version = attr_value(attrs, "version")

          unless @doc.version == "1.1"
            raise ParseError, "can only parse version 1.1 documents"
          end

          @doc.creator = attr_value(attrs, "creator")
          pedantic("missing creator attribute") unless @doc.creator

          push_state = :gpx
        else
          raise ParseError, "illegal root node"
        end

      when [:gpx]
        case name
        when "metadata"
          @metadata = Metadata.new
          push_state = :metadata
        when "trk"
          @track = Track.new
          push_state = :track
        end

      when [:gpx, :metadata]
        case name
        when "copyright"
          @copyright = Copyright.new
          push_state = :copyright
        when "author"
          @person = Person.new
          push_state = :author
        end

      when [:gpx, :metadata, :author]
        case name
        when "email"
          id = attr_value(attrs, "id")
          pedantic("missing id in email") unless id
          domain = attr_value(attrs, "domain")
          pedantic("missing domain in email") unless domain
          @person.email = "#{id}@#{domain}" if id and domain
        when "link"
          href = attr_value(attrs, "href")
          pedantic("missing href in link tag") unless href
          @link = Link.new.tap { |l| l.href = href }
          push_state = :link
        end

      when [:gpx, :track]
        case name
        when "trkseg"
          @segment = Segment.new
          push_state = :segment
        when "link"
          href = attr_value(attrs, "href")
          pedantic("missing href in link tag") unless href
          @link = Link.new.tap { |l| l.href = href }
          push_state = :link
        end

      when [:gpx, :track, :segment]
        case name
        when "trkpt"
          latitude = attr_value(attrs, "lat")
          pedantic("missing latitude") unless latitude

          longitude = attr_value(attrs, "lon")
          pedantic("missing longitude") unless longitude

          @waypoint = Waypoint.new(latitude.to_f, longitude.to_f)
          push_state = :waypoint
        end
      end

      @stack << push_state
    end

    def end_element(name)
      error("bad closing tag #{name}") unless @nodes.last == name

      case @stack
      when [:gpx, :metadata]
        @doc.metadata = @metadata
        @metadata = nil

      when [:gpx, :metadata, nil]
        case name
        when "name"
          @metadata.name = @buffer.dup
        when "desc"
          @metadata.description = @buffer.dup
        when "time"
          begin
            @metadata.time = Time.parse(@buffer)
          rescue ArgumentError
            raise ParseError, "could not parse metadata time"
          end
        end

      when [:gpx, :metadata, :copyright]
        @metadata.copyright = @copyright
        @copyright = nil

      when [:gpx, :metadata, :copyright, nil]
        case name
        when "year"
          @copyright.year = @buffer.dup
        when "license"
          @copyright.license = @buffer.dup
        when "author"
          @copyright.author = @buffer.dup
        end

      when [:gpx, :metadata, :author]
        @metadata.author = @person
        @person = nil

      when [:gpx, :metadata, :author, nil]
        case name
        when "name"
          @person.name = @buffer.dup
        end

      when [:gpx, :metadata, :author, :link]
        @person.link = @link
        @link = nil

      when [:gpx, :metadata, :author, :link, nil],
           [:gpx, :track, :link, nil]
        case name
        when "text"
          @link.text = @buffer.dup
        when "type"
          @link.type = @buffer.dup
        end

      when [:gpx, :track]
        @doc.tracks << @track
        @track = nil

      when [:gpx, :track, nil]
        case name
        when "name"
          @track.name = @buffer.dup
        when "cmt"
          @track.comment = @buffer.dup
        when "desc"
          @track.description = @buffer.dup
        when "src"
          @track.source = @buffer.dup
        when "number"
          @track.number = @buffer.to_i
        when "type"
          @track.type = @buffer.dup
        when "link"
          @link = Link.new
          push_state = :link
        end

      when [:gpx, :track, :link]
        @track.links << @link
        @link = nil

      when [:gpx, :track, :segment]
        @track.segments << @segment
        @segment = nil

      when [:gpx, :track, :segment, :waypoint]
        @segment.trackpoints << @waypoint
        @waypoint = nil

      when [:gpx, :track, :segment, :waypoint, nil]
        case name
        when "ele"
          @waypoint.elevation = @buffer.to_f
        when "time"
          begin
            @waypoint.time = Time.parse(@buffer)
          rescue ArgumentError
            pedantic("cannot parse waypoint time")
          end
        when "magvar"
          @waypoint.magvar = @buffer.to_f
        when "geoidheight"
          @waypoint.geoidheight = @buffer.to_f
        when "name"
          @waypoint.name = @buffer.to_s
        when "comment"
          @waypoint.comment = @buffer.to_s
        when "description"
          @waypoint.description = @buffer.to_s
        when "source"
          @waypoint.source = @buffer.to_s
        when "sym"
          @waypoint.sym = @buffer.to_s
        when "type"
          @waypoint.type = @buffer.dup
        when "fix"
          if %w(none 2d 3d dgps pps).include?(@buffer)
            @waypoint.fix = @buffer.to_sym
          else
            pedantic("illegal fix value")
          end
        when "satellites"
          @waypoint.satellites = @buffer.to_i
        when "hdop"
          @waypoint.hdop = @buffer.to_f
        when "vdop"
          @waypoint.vdop = @buffer.to_f
        when "pdop"
          @waypoint.pdop = @buffer.to_f
        when "age_of_dgps_data"
          @waypoint.age_of_dgps_data = @buffer.to_f
        when "dgps_id"
          @waypoint.dgps_id = @buffer.to_f
        end
      end

      @nodes.pop
      @stack.pop
    end

    def characters(string)
      @buffer << string
    end
  end
end
