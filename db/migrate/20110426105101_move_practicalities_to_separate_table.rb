class MovePracticalitiesToSeparateTable < ActiveRecord::Migration
  def self.up
    create_table "practicalities", :force => true do |t|
      t.integer  "poi_id"
      t.string   "email"
      t.string   "url"
      t.text     "hours"
      t.text     "price_string"
      t.string   "price_range"
    end
    ActiveRecord::Base.connection.execute "
    INSERT INTO practicalities (poi_id,email,url,hours,price_string,price_range)
    SELECT id, email, url,hours, price_string, price_range
    FROM pois"
    remove_column :pois, :email
    remove_column :pois, :url
    remove_column :pois, :hours
    remove_column :pois, :price_string
    remove_column :pois, :price_range
    add_index :practicalities, :poi_id
  end

  def self.down
    drop_table :practicalities
  end
end
