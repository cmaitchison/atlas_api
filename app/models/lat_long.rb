class LatLong
  attr_accessor :lat, :long
  
  def move bearing, distance
    radius = 6371.0
    distance = distance.to_f * 1.5 # Should actually be sqrt(2), but no need to be so precise.
    d = distance.to_f/radius  # d = angular distance covered on earths surface
    lat1 = to_rad @lat
    lon1 = to_rad @long
    brng = to_rad bearing.to_f

    lat2 = lat1 + d*Math.cos(brng)
    dLat = lat2-lat1
    dPhi = Math.log(Math.tan(lat2/2+Math::PI/4)/Math.tan(lat1/2+Math::PI/4))
    q = (dPhi!=0) ? dLat/dPhi : Math.cos(lat1) #E-W line gives dPhi=0
    dLon = d*Math.sin(brng)/q
    lon2 = (lon1+dLon+3*Math::PI) % (2*Math::PI) -Math::PI;
      
    lat2_deg = to_degrees(lat2)
    lon2_deg = to_degrees(lon2)
    LatLong.new lat2_deg, lon2_deg
  end  
  
  def to_rad angle
    angle/180 * Math::PI
  end
  
  def to_degrees angle
    angle*180 / Math::PI
  end
  
  def to_s
    "#{@lat},#{@long}"
  end 
  
  def initialize lat, long
    @lat = lat.to_f
    @long = long.to_f
  end
  
  def self.close_to lat, long, distance
    lat_long = LatLong.new lat, long
    distance = distance.to_f/1000.0
    ne = lat_long.move 45, distance
    sw = lat_long.move 225, distance
    [ne.lat, sw.lat, ne.long,sw.long]
  end
end