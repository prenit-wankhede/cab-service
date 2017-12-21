class CabRequest < ApplicationRecord
	belongs_to :customer, class_name: :User, inverse_of: :cab_requests
	belongs_to	:driver, class_name: :User, inverse_of: :service_requests, optional: true
end
