class AddIndexesToReviews < ActiveRecord::Migration
  def self.up
     add_index "reviews", ["poi_id"]
  end

  def self.down
    remove_index "reviews", ["poi_id"]
  end
end
