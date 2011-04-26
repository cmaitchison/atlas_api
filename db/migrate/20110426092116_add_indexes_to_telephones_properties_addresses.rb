class AddIndexesToTelephonesPropertiesAddresses < ActiveRecord::Migration
  def self.up
     add_index "telephones", ["poi_id"]
     add_index "addresses", ["poi_id"]
     add_index "properties", ["poi_id"]
      
    begin
      remove_index "pois", :name => "index_pois_on_place_ancestry_names"
    rescue
    #ignore if index does not already exist
    end
    ActiveRecord::Base.connection.execute "CREATE INDEX index_pois_on_place_ancestry_names ON pois (place_ancestry_names varchar_pattern_ops);"
  end

  def self.down
    remove_index "telephones", ["poi_id"]
    remove_index "addresses", ["poi_id"]
    remove_index "properties", ["poi_id"]
    remove_index "pois", :name => "index_pois_on_place_ancestry_names"
  end
end
