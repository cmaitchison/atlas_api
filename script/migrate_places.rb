require 'pg'

def quote value
  return "NULL" if value.nil?
  return value if value.class != String
  "'#{value}'"
end
PGconn.new({:host=>"localhost",:user=>"cmaitchison",:password=>"",:dbname=>"lp_api_dev"}) do |conn|
  Place.find_each do |place|
    id = place.id 
    name = quote place.name.gsub(/'/, "")
    ethyl_id = quote place.ethyl_id
    iso_3166_1 = quote place.iso_3166_1
    woeid = quote place.woeid 
    parent_id = quote place.parent_id 
    north = quote place.north 
    south = quote place.south 
    east = quote place.east 
    west = quote place.west 
    calling_code = quote place.calling_code
    query = "INSERT INTO PLACES (id, name, ethyl_id, iso_3166_1, woeid, parent_id, north, south, east, west)
    VALUES (#{id}, #{name}, #{ethyl_id}, #{iso_3166_1}, #{woeid}, #{parent_id},#{north}, #{south}, #{east}, #{west})"
    puts query
    conn.exec(query)
  end
end