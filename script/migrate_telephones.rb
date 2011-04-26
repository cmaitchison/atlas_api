require 'pg'

PGconn.new({:host=>"localhost",:user=>"cmaitchison",:password=>"",:dbname=>"lp_api_dev"}) do |conn|
  
  Place.find_each(:conditions => "calling_code is not null") do |place|
    id = place.id 
    calling_code = place.calling_code
    query = "update PLACES set calling_code = #{calling_code} where id=#{id}"
    puts query
    conn.exec(query)
  end
end