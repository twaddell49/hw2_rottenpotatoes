class Movie < ActiveRecord::Base
	#sources:  Stack Overflow
	#collaborators: Chad Bryant, John Usery
	def Movie.get_ratings
		ratings = ['G', 'PG', 'PG-13', 'R']
		return ratings
	end

end
