class DriversController < ApplicationController

	def index 
		if(params[:id])
			@waiting_requests = CabRequest.where(status: :waiting) 
			@ongoing_requests = CabRequest.where(status: :ongoing, driver_id: params[:id])
			@complete_requests = CabRequest.where(status: :complete, driver_id: params[:id])
		else
			render plain: "customer_id must be present in request params"
		end
	end
end
