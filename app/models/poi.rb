class Poi < ActiveRecord::Base
  
  belongs_to :place
  has_many :addresses
  has_many :telephones
  has_many :properties
  has_many :reviews
  has_many :practicalities
  
  before_save :refresh_ancestry
  
  set_inheritance_column :sti_type
  
  def self.build_ancestry
    ActiveRecord::Base.connection.execute "UPDATE pois SET place_ancestry_ids = (SELECT ancestry_ids FROM places WHERE places.id = pois.place_id) WHERE pois.place_ancestry_ids is null"
    ActiveRecord::Base.connection.execute "UPDATE pois SET place_ancestry_names = (SELECT ancestry_names FROM places WHERE places.id = pois.place_id) WHERE pois.place_ancestry_names is null"
  end

  def refresh_ancestry
    self.place_ancestry_ids = place.ancestry_ids
    self.place_ancestry_names = place.ancestry_names
  end
  
  def place_name
    refresh_ancestry unless place_ancestry_names
    place_ancestry_names.split("~").last if place_ancestry_names
  end
 
end
