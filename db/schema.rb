# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110424170014) do

  create_table "places", :force => true do |t|
    t.string  "name"
    t.string  "ethyl_id"
    t.string  "iso_3166_1"
    t.string  "woeid"
    t.integer "parent_id"
    t.decimal "north"
    t.decimal "south"
    t.decimal "east"
    t.decimal "west"
    t.string  "searchable_name"
    t.string  "ancestry_ids"
    t.string  "ancestry_names"
  end

  add_index "places", ["ancestry_ids"], :name => "index_places_on_ancestry_ids"
  add_index "places", ["ancestry_names"], :name => "index_places_on_ancestry_names"
  add_index "places", ["east"], :name => "index_places_on_east"
  add_index "places", ["ethyl_id"], :name => "index_places_on_ethyl_id"
  add_index "places", ["north"], :name => "index_places_on_north"
  add_index "places", ["parent_id"], :name => "index_places_on_parent_id"
  add_index "places", ["searchable_name"], :name => "index_places_on_searchable_name"
  add_index "places", ["south"], :name => "index_places_on_south"
  add_index "places", ["west"], :name => "index_places_on_west"
  add_index "places", ["woeid"], :name => "index_places_on_woeid"

  create_table "pois", :force => true do |t|
    t.string   "ethyl_id"
    t.string   "feature_id"
    t.integer  "place_id"
    t.string   "type"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "name"
    t.string   "alt_name"
    t.string   "subtype"
    t.string   "telephone"
    t.string   "email"
    t.string   "url"
    t.text     "review_summary"
    t.text     "review_detail"
    t.text     "hours"
    t.text     "price_string"
    t.string   "price_range"
    t.string   "address_street"
    t.string   "address_locality"
    t.string   "address_postcode"
    t.string   "address_extras"
    t.string   "address_region"
    t.string   "address_neighbourhood"
    t.datetime "verified_on"
    t.string   "searchable_name"
    t.string   "place_ancestry_ids"
    t.string   "place_ancestry_names",  :limit => 512
  end

  add_index "pois", ["ethyl_id"], :name => "index_pois_on_ethyl_id"
  add_index "pois", ["feature_id"], :name => "index_pois_on_feature_id"
  add_index "pois", ["latitude"], :name => "index_pois_on_latitude"
  add_index "pois", ["longitude"], :name => "index_pois_on_longitude"
  add_index "pois", ["place_ancestry_ids"], :name => "index_pois_on_place_ancestry_ids"
  add_index "pois", ["place_ancestry_ids"], :name => "test_index"
  add_index "pois", ["place_ancestry_names"], :name => "index_pois_on_place_ancestry_names"
  add_index "pois", ["searchable_name"], :name => "index_pois_on_searchable_name"
  add_index "pois", ["type"], :name => "index_pois_on_type"

end
