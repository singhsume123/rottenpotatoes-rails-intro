class Movie < ActiveRecord::Base
	def self.All_Ratings
		Movie.uniq.pluck(:rating)
	end
end
