class PlacesController < ApplicationController
  
  respond_to :json
  
  DEFAULT_LIMIT = 1000
  
  def index
      build_place_scope
      render :json => @places
  end

  def build_place_scope
    limit = params[:limit] || 1000
    @places = Place.limit(limit)
    @places = @places.order(:ancestry_names)
    @places = @places.offset(params[:offset]) if params[:offset] 
    
    set_selected_fields
    filter_by_name
    filter_by_parent
    filter_by_lat_long
    filter_by_id
  end
  
  def set_selected_fields
    return unless params["select"]
    selected_fields = params[:select].split(",") 
    @places = @places.select(selected_fields) if selected_fields
    @places = @places.select("id")
  end
  
  def filter_by_id
    id = where_param :id
    @places = @places.where("id = ?", id.to_i) if id
  end
  
  def filter_by_name
    @places = @places.where("lower(searchable_name) like ?", param_name.downcase) if param_name
  end
  
  def filter_by_lat_long
    lat, long = param_contains_point
    return unless lat && long
    @places = @places.where("north > ? AND south < ? AND east > ? AND west < ?", lat,lat, long, long) 
  end
  
  def filter_by_parent
    parent = param_parent
    return unless parent
    @places = @places.where("ancestry_ids like ?", parent.ancestry_ids + "%")
  end
  
  def param_parent
    parent_id = where_param(:parent) if where_param(:parent)
    return unless parent_id
    Place.find(parent_id)
  end
  
  def param_contains_point
     return nil unless where_param :contains_point
     point = where_param(:contains_point).split(",")
     return nil unless point.length == 2
     lat = point[0]
     long =point[1]
     [lat.to_f,long.to_f]
  end
end
