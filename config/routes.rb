Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  get :driverapp, to: "drivers#index" do

  end
  
  get :customerapp, to: "customers#index" do
 
  end

  get :dashboard, to: "dashboard#index"

  namespace :api do
  	namespace :one do
  		resources :cab_requests	do
  			member do 
  				post "process_request"
  			end
  		end
  	end
  end
end
