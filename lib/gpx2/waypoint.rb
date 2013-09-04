module GPX2
  class Waypoint
    attr_accessor :elevation
    attr_accessor :time
    attr_accessor :magvar
    attr_accessor :geoidheight
    attr_accessor :name
    attr_accessor :comment
    attr_accessor :description
    attr_accessor :source
    attr_accessor :sym
    attr_accessor :type
    attr_accessor :fix
    attr_accessor :satellites
    attr_accessor :hdop
    attr_accessor :vdop
    attr_accessor :pdop
    attr_accessor :age_of_dgps_data
    attr_accessor :dgps_id
    attr_accessor :latitude
    attr_accessor :longitude

    attr_reader :links

    def initialize(latitude = nil, longitude = nil)
      @links = []

      if latitude
        if latitude.kind_of?(Numeric)
          self.latitude = latitude
        else
          raise TypeError, "latitude must be a number"
        end
      end

      if longitude
        if longitude.kind_of?(Numeric)
          self.longitude = longitude
        else
          raise TypeError, "longitude must be a number"
        end
      end
    end
  end
end
