module ApplicationHelper
	def self.find_nearest_three_drivers(cab_request)
		nearest_three_drivers = []
		distance_from_drivers = []
		for i in 1..5 do
			distance_from_drivers[i-1] = Math.sqrt((cab_request.latitude - i)**2 + (cab_request.longitude - i)**2)	
		end
		sorted_distance_from_drivers = distance_from_drivers.sort
		for i in 1..3 do
			nearest_three_drivers[i-1] = distance_from_drivers.find_index(sorted_distance_from_drivers[i-1]) + 1
		end
		return nearest_three_drivers
	end
end
