class CabRequestWorker
  include Sidekiq::Worker

  def perform(cab_request_id, message_js)
  	@cab_request = CabRequest.find_by(id: cab_request_id)
  	if(@cab_request)
  		@cab_request.update(status: "complete", finished_at: Time.now)
		ActionCable.server.broadcast( "driver_#{@cab_request.driver_id}", message_js)
  	end
  end
end
