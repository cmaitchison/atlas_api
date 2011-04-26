class MoveAddressesIntoSeparateTable < ActiveRecord::Migration
  def self.up
    create_table "addresses", :force => true do |t|
      t.integer   "poi_id"
      t.string   "street"
      t.string   "locality"
      t.string   "postcode"
      t.string   "extras"
      t.string   "region"
      t.string   "neighbourhood"
    end
    ActiveRecord::Base.connection.execute "
    INSERT INTO addresses (poi_id,street,locality, postcode, extras, region, neighbourhood) 
    SELECT id, address_street, address_locality, address_postcode, address_extras, address_region, address_neighbourhood
    FROM pois"
    remove_column :pois, :address_street
    remove_column :pois, :address_locality
    remove_column :pois, :address_postcode
    remove_column :pois, :address_extras
    remove_column :pois, :address_region
    remove_column :pois, :address_neighbourhood
  end

  def self.down
    drop_table :addresses
  end
end
