#require 'mongoid/document'

module YTravel
	class Landmark
		#include Mongoid::Document
    	#include Mongoid::Timestamps::Created
		#include Geocoder::Model::Mongoid
		
		attr_accessor :headline, :description, :location

		#field :address
		#geocoded_by :address               # can also be an IP address
		#after_validation :geocode  
		
		def find_landmarks(location)

		end
	end
end

