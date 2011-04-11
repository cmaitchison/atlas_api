require 'pg'

PGconn.new({:host=>"localhost",:user=>"cmaitchison",:password=>"",:dbname=>"lp_api_dev"}) do |conn|
  Place.find_each do |place|
    id = place.id 
    name = place.name.gsub(/'/, "") || 'null'
    ethyl_id = place.ethyl_id || 'null'
    iso_3166_1 = place.iso_3166_1 || 'null'
    woeid = place.woeid || 'null'
    parent_id = place.parent_id || 'null'
    north = place.north || 'null'
    south = place.south || 'null'
    east = place.east || 'null'
    west = place.west || 'null'
    query = "INSERT INTO PLACES (id, name, ethyl_id, iso_3166_1, woeid, parent_id, north, south, east, west)
    VALUES (#{id}, '#{name}', '#{ethyl_id}','#{iso_3166_1}','#{woeid}', #{parent_id},#{north}, #{south}, #{east}, #{west})"
    puts query
    conn.exec(query)
  end
end