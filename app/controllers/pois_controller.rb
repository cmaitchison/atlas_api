class PoisController < ApplicationController
  
  def index
    Rails.logger.info params
    build_pois_scope
    render :json => @pois
  end
   
  def build_pois_scope
    limit = params[:limit] || 1000
    @pois = Poi.limit(limit)

    set_selected_fields || set_detailed_fields   
    filter_by_name
    filter_by_place
    filter_by_contained_in
    filter_by_close_to
    filter_by_type
    filter_by_geocoded
  end

  def set_detailed_fields
    default_fields=[:id,:name, :ethyl_id, :feature_id, :type, :latitude, :longitude, :alt_name, :subtype, :place_ancestry_names, :place_ancestry_ids]
    return if param_detailed
    @pois = @pois.select(default_fields) 
  end
  
  def set_selected_fields
     return unless params["select"]
     selected_fields = params[:select].split(",") 
     @pois = @pois.select(selected_fields) if selected_fields
     @pois = @pois.select("id")
  end
  
  def filter_by_geocoded
    geocoded = where_param :geocoded
    return unless geocoded
    is_geocoded = (geocoded.downcase == 'true')
    if is_geocoded
      @pois = @pois.where('latitude is not null AND longitude is not null')
    else
      @pois = @pois.where('latitude is null OR longitude is null')
    end
  end
  
  def filter_by_type
    type = where_param :type
    return unless type
    @pois = @pois.where("lower(type) = ?", type.downcase)
  end   
  
  def filter_by_close_to
    lat, long, distance = param_close_to
    return unless lat && long && distance
    north, south, east, west = LatLong.close_to lat, long, distance
    @pois = @pois.where("longitude > ? AND longitude < ? AND latitude > ? AND latitude < ?", west, east, south, north) 
  end
  
  def filter_by_name
     @pois = @pois.where("lower(searchable_name) like ?", param_name.downcase) if param_name
  end
  
  def filter_by_place
    place_id = where_param :place
    return unless place_id
    place = Place.find(place_id)
    place_ancestry_ids = place.ancestry_ids
    return unless place_ancestry_ids
    @pois = @pois.where("place_ancestry_ids like ?", place_ancestry_ids + "%")
  end
  
  def filter_by_contained_in
     north, south, east, west = param_contained_in
     return unless north && south && east && west
     @pois = @pois.where("longitude > ? AND longitude < ? AND latitude > ? AND latitude < ?", west, east, south, north) 
   end
   
  def param_detailed
    return false unless params[:detailed]
    params[:detailed].downcase == 'true'
  end
  
  def param_contained_in
      return nil unless where_param :contained_in
      box = where_param(:contained_in).split(",")
      return nil unless box.length == 4
      north = box[0].to_f
      south = box[1].to_f
      east = box[2].to_f
      west = box[3].to_f
      [north, south, east, west]
   end
   
   def param_close_to
       return nil unless where_param :close_to
       where_param(:close_to).split(",")
    end
end
