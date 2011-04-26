class AddPoiProperties < ActiveRecord::Migration
  def self.up
    create_table "properties", :force => true do |t|
       t.string   "key",         :limit => 50,  :null => false
       t.string   "value",       :limit => 200
       t.datetime "created_at"
       t.integer  "poi_id",                :null => false
     end
  end

  def self.down
    drop_table "properties"
  end
end
