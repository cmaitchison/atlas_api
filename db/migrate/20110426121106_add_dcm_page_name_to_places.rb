class AddDcmPageNameToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :dcm_page_name, :string
  end

  def self.down
    remove_column :places, :dcm_page_name
  end
end
