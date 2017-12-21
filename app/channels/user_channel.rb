class UserChannel < ApplicationCable::Channel
  def subscribed
  	if current_user.is_online != true
		current_user.is_online = true
		current_user.save
	end	
    stream_from "user_#{current_user.id}"

  end

  def unsubscribed
	# Any cleanup needed when channel is unsubscribed
	if current_user.is_online == true
		current_user.is_online = false
		current_user.save
	end
	ActionCable.server.remote_connections.where(current_user: current_user).disconnect
    current_user = nil
  end
end
