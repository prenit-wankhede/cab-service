class UserChannel < ApplicationCable::Channel
  def subscribed
  	stream_from "driver_#{params[:driver_id]}"
  end

  def unsubscribed
	# Any cleanup needed when channel is unsubscribed
  end
end
