require 'pg'

def connection 
  @connection ||= PGconn.new({:host=>"localhost",:user=>"cmaitchison",:password=>"",:dbname=>"lp_api_dev"})
end

def log message
  open('migrate_api.log', 'a') do |f|
    f.puts message
  end
end

def max_poi
   result = execute "SELECT MAX(ID) FROM POIS"
   max = result[0].max[1].to_i
   puts "ID - #{max}"
   max
end
def clean value
  return 'null' if value.nil?
  return value unless value.class == String
  PGconn.escape value
end

def execute query
  begin
    connection.exec(query)
  rescue
    puts query
  end
end

start_time = Time.now
log "Starting at #{start_time.inspect}"
Poi.find(:all, :conditions => "id >  #{max_poi}", :limit => 200).each do |o_poi|
    poi = Poi.find(o_poi.id)

    id = poi.id 
    pl = poi.default_localisation
    if pl.nil? || pl.id.nil?
      puts "#{id} nil default_localisation"
      next
    end
    
    if poi.place.nil? || poi.place.id.nil?
      puts "#{id} nil place"
      next
    end
    
    ethyl_id = clean poi.ethyl_id
    feature_id = clean poi.feature_id
    place_id = clean poi.place.id
   
    type = clean pl.type 
    longitude = clean pl.longitude
    latitude = clean pl.latitude
    name = clean poi.name 
    subtype = clean poi.subtype
    
    raw_telephone = pl.telephones.first.click_to_dial if pl.telephones.first
    telephone = clean raw_telephone
    raw_email = pl.emails.first
    email = clean raw_email
    
    raw_url = pl.urls.first
    url = clean raw_url
    
    review_summary = clean pl.review.summary if pl.review
    review_detail = clean pl.review.detail if pl.review
    
    hours = clean pl.hours
    price_string = clean pl.price_string
    price_range = clean pl.price_range
    
    address = pl.address
    if address
      address_street = clean address.street
      address_locality = clean pl.address.locality 
      address_postcode = clean pl.address.postcode
      address_extras = clean pl.address.extras 
      address_region = clean pl.address.region
      address_neighbourhood = clean pl.address.neighbourhood
    end
    verified_on = clean pl.verified_on
    
    alt_name= clean pl.alt_name
    searchable_name= clean pl.searchable_name
    
    query = "INSERT INTO POIS (id, ethyl_id, feature_id, place_id, type, latitude, longitude, 
      name, subtype, telephone, email, url, review_summary, review_detail, hours, price_string,
        price_range, address_street, address_locality, address_postcode, address_extras, address_region,
          address_neighbourhood, verified_on, alt_name, searchable_name)
    VALUES (#{id}, '#{ethyl_id}','#{feature_id}',#{place_id}, '#{type}', #{latitude}, #{longitude},
      '#{name}', '#{subtype}', '#{telephone}','#{email}','#{url}', '#{review_summary}', '#{review_detail}','#{hours}', '#{price_string}',
        '#{price_range}', '#{address_street}', '#{address_locality}','#{address_postcode}','#{address_extras}', '#{address_region}',
          '#{address_neighbourhood}', '#{verified_on}', '#{alt_name}', '#{searchable_name}')"
    
    execute query
end

puts "200 done in #{Time.now - start_time}"
puts "Finishing at #{Time.now.inspect}"