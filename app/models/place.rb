class Place < ActiveRecord::Base
  include Jsonnable
  
  before_save :refresh_ancestry
  
  def self.build_ancestry
    Place.find(:all, :conditions => "ancestry_ids is null OR ancestry_names is null").each do |place|
      place.save!
    end
  end
  
  def refresh_ancestry
    temp_ancestry_ids = ""
    temp_ancestry_names= ""
    parents.each do |parent|
      temp_ancestry_ids += (parent.id.to_s + "~")
      temp_ancestry_names += (parent.name + "~")
    end
    temp_ancestry_ids += id.to_s
    temp_ancestry_names += name
    self.ancestry_ids = temp_ancestry_ids
    self.ancestry_names = temp_ancestry_names
  end
  
  def parents
    return [] if parent_id.nil?
    parent_places = parent.parents
    parent_places << parent
  end
  
  def parent
    Place.find_by_id(parent_id)
  end
  
  def as_json(options = nil)
    hash = {'id' => id}
    add_field hash, :name
    add_field hash, :full_name
    add_field hash, :ethyl_id
    add_field hash, :iso_3166_1
    add_field hash, :woeid
    add_field hash, :ethyl_id
    add_field hash, :iso_3166_1
    add_field hash, :woeid
    add_field hash, :parent_id
    add_field hash, :north
    add_field hash, :south
    add_field hash, :east
    add_field hash, :west
    hash = { self.class.model_name.element => hash } if include_root_in_json
    hash
  end
  
end
