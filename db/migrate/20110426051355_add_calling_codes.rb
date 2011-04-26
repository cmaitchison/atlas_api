class AddCallingCodes < ActiveRecord::Migration
  def self.up
    add_column :places, :calling_code, :string, :limit => 3
  end

  def self.down
    remove_column :places, :calling_code
  end
end
