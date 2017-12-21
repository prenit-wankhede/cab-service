class Api::One::CabRequestsController < ApplicationController

	skip_before_action :verify_authenticity_token

	def create
		@cab_request = current_user.cab_requests.new(status: :waiting)
		if(@cab_request.save)
			render json: {message: :created}
		else
			render json: {message: :falied}, status: 500
		end
	end
end
