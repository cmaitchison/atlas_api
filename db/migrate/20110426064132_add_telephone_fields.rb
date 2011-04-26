class AddTelephoneFields < ActiveRecord::Migration
  def self.up
    add_column :telephones, :click_to_dial, :string
    add_column :telephones, :country_code, :string
  end

  def self.down
    remove_column :telephones, :click_to_dial
    remove_column :telephones, :country_code
  end
end
