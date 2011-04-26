class PlacesController < ApplicationController
  ActiveRecord::Base.include_root_in_json = false
  respond_to :json
  
  def index
    build_places_scope
    render :json => json_response
  end

  def json_response
    response_json = "{ \"places\" :["
    place_jsons=[]
    @places.each do |place|
      place_json = Rails.cache.fetch place do
        place.reload
        place.to_json
      end
      place_jsons << place_json
    end
    response_json += place_jsons.join ","
    response_json += "]}"
  end
  
  def build_places_scope
    limit = params[:limit] || 1000
    @places = Place.limit(limit)
    @places = @places.select(:id)
    @places = @places.order(:ancestry_names)
    @places = @places.offset(params[:offset]) if params[:offset] 
    
    filter_by_name
    filter_by_parent
    filter_by_lat_long
    filter_by_id
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
