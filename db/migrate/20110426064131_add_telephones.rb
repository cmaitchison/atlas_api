class AddTelephones < ActiveRecord::Migration
  def self.up
     create_table "telephones", :force => true do |t|
        t.string   "area_code",         :limit => 10
        t.string   "number",                           :null => false
        t.string   "text",              :limit => 100
        t.datetime "created_at"
        t.string   "searchable_number", :limit => 100
        t.integer  "poi_id",                      :null => false
      end
  end

  def self.down
   drop_table :telephones
  end
end
