class Poi < ActiveRecord::Base
  include Jsonnable
  belongs_to :place
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
 
  def as_json(options = nil)
    hash = {'id' => id}
    add_field hash, :name
    add_field hash, :place_ancestry_ids
    add_field hash, :place_ancestry_names
    add_field hash, :ethyl_id
    add_field hash, :feature_id
    add_field hash, :type
    add_field hash, :latitude
    add_field hash, :longitude
    add_field hash, :alt_name
    add_field hash, :subtype
    add_field hash, :telephone
    add_field hash, :email
    add_field hash, :price_string
    add_field hash, :price_range
    add_field hash, :review_summary
    add_field hash, :review_detail
    
    hash = { self.class.model_name.element => hash } if include_root_in_json
    hash
  end

end
