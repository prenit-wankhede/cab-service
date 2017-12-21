class DashboardController < ApplicationController
	
	def index
		@cab_requests = CabRequest.all.order(created_at: :desc)
	end

end
