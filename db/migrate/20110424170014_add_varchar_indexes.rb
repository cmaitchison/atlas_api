class MissingIndexes < ActiveRecord::Migration
  def self.up
    begin
      remove_index "pois", :name => "index_pois_on_place_ancestry_ids"
    rescue
      #ignore if index does not already exist
    end
    ActiveRecord::Base.connection.execute "CREATE INDEX index_pois_on_place_ancestry_ids ON pois (place_ancestry_ids varchar_pattern_ops);"
  end

  def self.down
    remove_index "pois", :name => "index_pois_on_place_ancestry_ids"
  end
end
