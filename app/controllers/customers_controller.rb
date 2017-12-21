class CustomersController < ApplicationController

	def index
		@cab_requests = current_user.cab_requests
		@waiting_requests = @cab_requests.where(status: :waiting)
		@ongoing_requests = @cab_requests.where(status: :ongoing)
		@complete_requests = @cab_requests.where(status: :complete)
	end
	
	def create_request

	end
end
