class Api::One::CabRequestsController < ApplicationController

	skip_before_action :verify_authenticity_token

	def index
		@all_waiting_requests = CabRequest.where(status: :waiting)
		@waiting_requests = []
		@all_waiting_requests.each do |request|
			nearest_three_drivers = ApplicationHelper.find_nearest_three_drivers(request)
			if(nearest_three_drivers.include?(params[:driver_id].to_i))
				@waiting_requests << request
			end
		end
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
		@waiting_requests = CabRequest.where(status: :waiting)
		if(@waiting_requests.length > 10)
			render json: {message: :failed, reason: "Rides not available. try again later"}, status: 500
			return
		end
		@cab_request = CabRequest.new(customer_id: params[:customer_id], status: :waiting, latitude: params[:latitude], longitude: params[:longitude])
		if(@cab_request.save)
			render json: {message: :created, cab_request_id: @cab_request.id, latitude: params[:latitude], logitude: params[:longitude]}
			nearest_three_drivers = ApplicationHelper.find_nearest_three_drivers(@cab_request)
			nearest_three_drivers.each do |nearest_driver_id|
				message_js = render_to_string partial: "create", locals: {cab_request: @cab_request}
				ActionCable.server.broadcast( "driver_#{nearest_driver_id}", message_js)
			end
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
				@cab_request.updated_at = Time.now
				if(@cab_request.save)
					render json: {message: "selected", cab_request_id: @cab_request.id, created_at: @cab_request.created_at, customer_id: @cab_request.customer_id}
					message_js = render_to_string partial: "selected", locals: {cab_request: @cab_request}
					for i in 1..5 do
						if(i != params[:driver_id].to_i)
							ActionCable.server.broadcast( "driver_#{i}", message_js)
						end
					end
					message_js = render_to_string partial: "complete", locals: {cab_request: @cab_request}
					::CabRequestWorker.perform_in(5.minutes, @cab_request.id, message_js)
				else
					render json: {message: :falied}, status: 500
				end
			else
				render json: {message: :failed, reason: "request no longer available"}, status: 500
			end
		else
			render json: {message: :failed, reason: "already serving one cab request"}, status: 500
		end
	end
end
