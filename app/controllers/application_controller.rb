class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def param_name
    where_param(:name).gsub(/\*/,"%") if where_param(:name)
  end
  
  def where_param field
   params[:where][field] if params[:where]
  end
  
end
