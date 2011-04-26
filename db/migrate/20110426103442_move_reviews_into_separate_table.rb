class MoveReviewsIntoSeparateTable < ActiveRecord::Migration
  def self.up
        create_table "reviews", :force => true do |t|
          t.integer  "poi_id"
          t.text   "summary"
          t.text   "detailed"
        end
        ActiveRecord::Base.connection.execute "
        INSERT INTO reviews (poi_id,summary,detailed)
        SELECT id, review_summary, review_detail
        FROM pois"
        remove_column :pois, :review_summary
        remove_column :pois, :review_detail
      end

      def self.down
        drop_table :reviews
      end
end
