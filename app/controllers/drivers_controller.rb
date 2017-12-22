class DriversController < ApplicationController

	def index 
		if(params[:id])
			@all_waiting_requests = CabRequest.where(status: :waiting)
			@waiting_requests = []
			@all_waiting_requests.each do |request|
				nearest_three_drivers = ApplicationHelper.find_nearest_three_drivers(request)
				if(nearest_three_drivers.include?(params[:id].to_i))
					@waiting_requests << request
				end
			end
			@ongoing_requests = CabRequest.where(status: :ongoing, driver_id: params[:id])
			@complete_requests = CabRequest.where(status: :complete, driver_id: params[:id])
		else
			render plain: "customer_id must be present in request params"
		end
	end
end
