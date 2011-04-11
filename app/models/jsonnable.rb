module Jsonnable
  
  def add_field hash, attribute_name
     attribute_value = get_potentially_missing_attribute attribute_name   
     return if attribute_value.nil? || attribute_value == 'null'
     hash.merge!({attribute_name.to_s => attribute_value})
   end

   def get_potentially_missing_attribute method_name   
     method(method_name).call if has_attribute? method_name
   end
  
end
