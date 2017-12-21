class DashboardController < ApplicationController
	
	def index
		@cab_requests = CabRequest.where.not(status: :complete)
	end

end
