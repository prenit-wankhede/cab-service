class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :cab_requests, class_name: :CabRequest, foreign_key: :customer_id       
  has_many :service_requests, class_name: :CabRequest, foreign_key: :driver_id
end
