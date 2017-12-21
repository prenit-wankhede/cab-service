class Api::One::CabRequestsController < ApplicationController

	skip_before_action :verify_authenticity_token

	def index
		@waiting_requests = CabRequest.where(status: :waiting)
		@ongoing_requests = CabRequest.where(status: :ongoing, driver_id: params[:driver_id])
		@complete_requests = CabRequest.where(status: :complete, driver_id: params[:driver_id])
		respond_to do |format|
		  format.html
		  format.json do 
		  	render json: {waiting_requests: @waiting_requests, ongoing_requests: @ongoing_requests, complete_requests: @complete_requests}
		  end
		end
	end

	def create
		@cab_request = CabRequest.new(customer_id: params[:customer_id], status: :waiting)
		if(@cab_request.save)
			render json: {message: :created, cab_request_id: @cab_request.id}
		else
			render json: {message: :falied}, status: 500
		end
	end

	def process_request
		@drivers_ongoing_requests = CabRequest.where(status: :ongoing, driver_id: params[:driver_id])
		if(@drivers_ongoing_requests.length == 0) 
			@cab_request = CabRequest.find_by(id: params[:id])
			if(@cab_request.status == "waiting")
				@cab_request.status = "ongoing"
				@cab_request.driver_id = params[:driver_id]
				if(@cab_request.save)
					::CabRequestWorker.perform_in(5.minutes, @cab_request.id)
					render json: {message: :selected}
				else
					render json: {message: :falied}, status: 500
				end
			else
				render json: {message: :failed, reason: "“request no longer available"}, status: 500
			end
		else
			render json: {message: :failed, reason: "already serving one cab request"}, status: 500
		end
	end
end
