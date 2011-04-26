class Telephone < ActiveRecord::Base
  belongs_to :poi
  
  before_save :update_click_to_dial
  
  def a_click_to_dial
     cleaned_number = clean self.number

     return nil if cleaned_number.nil? ||
       is_emergency?(cleaned_number)

     "+#{country_calling_code} #{clean_area_code} #{cleaned_number}".squish
   end

   def country_calling_code
     country_code || place.calling_code
   end

   def place
     @place ||= poi.place
   end

   private

   def is_emergency? number_string
     number_string.size <= 3
   end

   def clean number_string
     if number_string
       number_string.
         gsub(/^0+/, ''). # remove leading zeroes
         gsub(/\-/, ' ') # replace hyphens with spaces
     end
   end

   def clean_area_code
     self.area_code ? self.area_code.gsub(/^0+/, '')  : ''
   end

   def update_searchable_number
     self.searchable_number= number ? number.gsub(/\D/, "").reverse : number
   end
   
   def update_click_to_dial
      if poi.nil?
        self.destroy
        return false
      end
      self.country_code = place.calling_code
      self.click_to_dial = a_click_to_dial
   end
end