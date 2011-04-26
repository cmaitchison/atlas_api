require 'pg'

PGconn.new({:host=>"localhost",:user=>"cmaitchison",:password=>"",:dbname=>"lp_api_dev"}) do |conn|
  Place.find_each(:conditions => "dcm_page_name is not null") do |place|
    id = place.id 
    dcm_page_name =  PGconn.escape place.dcm_page_name
    query = "UPDATE PLACES SET dcm_page_name = '#{dcm_page_name}' where id = #{id}"
    puts query
    conn.exec(query)
  end
end