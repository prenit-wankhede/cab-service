# README

A simple cab request application for drivers and customer. Customer can place a cab request and one of 5 drivers will pick the request if the are available. 

* Ruby version
	```2.1 and above```

* Rails version
	```5.1.4```

* System dependencies
	```Ruby, Rails, MySQL (development), Postgres (production), node.js, redis```

* Configuration
	run ```set RAILS_ENV=production```

* Database creation
	edit config/database.yml file and set MySQL usename and passpord for development env and setup Postgress for production env
	
	run ```rake db:create```

* Database initialization
	run ```rake db:migrate```
	
* Services (job queues, cache servers, search engines, etc.)
	run ```bundle exec sidekiq -C congig/sidekiq.yml```

* Deployment instructions
	Run following commands:

	```
	git clone "https://bitbucket.org/prenit/cab_service"
	cd cab_service
	bundle install
	rake db:create
	rake db:migrate
	bundle exec sidekiq
	rails s
	```

* Database Used
	* Engine: MySQL on local machine, Postgres on production
	* Database Name: cab_service_development, cab_service_test on development, cab_service_production on production
	* Tables: 
		* cab_requests 
			* Columns:   
			id(integer),  
			 customer_id(integer),  
			  driver_id(integer),  
			   status(string),  
			    created_at(timestamp),  
			     updated_at(timestamp),  
			      finished_at(timestamp)  

		* users (Optional. Present if Devise authentication is turned on)
			* Columns: id(integer),  
			            email(string),  
			             passpord(string),  
			              is_online(boolean),  
			               created_at(timestamp),  
			                updated_at(timestamp)  

* Overview of Backed architecture
	
	* We have used MVC architecture of rails 

	* List of Models

		* CabRequest:  
			id,  
			customer_id,  
			driver_id,  
			status,  
			created_at,
			updated_at,  
			finished_at

	* List of Controllers

		* ApplicationController (Rails default) responsible for initial handling of all requests that come to server
			
			enable/disable Devise user authentication by commenting out the 'authenticate_user!'' line
		
		* CabRequestsController

			* Methods

				index: returns drivers waitin, ongoing and complete cab requests  
				
				create: creats a new cab request for given customer  
				
				process_request: allocates given request to given drive if driver is available and request is not picked by other driver

		* CustomersController

			* methods

				index: renders HTML page for customer app			

		* DriversController

			* methods

				index: renders HTML page for driver app			

		* DashboardController

			* methods

				index: renders HTML page for dashboard app							

	* List of Background Workers

		* CabRequestWorker

			perform: updates the ongoing requests as complete 5 min after request is picked by a driver and marks requests status as complete

    * We have used 'sidekiq' gem for background job processing and redis for cache and in memory database


* List of HTML APIs

	* Customer app

	```
	path: "/customerapp.html",
	method: "GET",
	response: HTML page with form to fill customer id and send cab request
	```

	* Driver app

	```
	path: "driverapp.html?id={driver_id}",
	method: "GET",
	params: {id: driver_id}, // required params. if not present error message page will be sent wth status code 200,
	response: HTML page listing driver's waiting, ongoing and complete cab requests. Driver can select waiting rides if he is available. Button to asynchronously refresh the lists
	```

	* Dashboard app

    ```
	path: "/dashboard.html",
	method: "GET"
	response: HTML page listing all cab requests with thier id, time of request, time elapsed and status
    ```

* List of JSON APIs
	
	* Cab Requests API
	
	    * Get cab requests // Client Facing

	```
	path: "/api/one/cab_requests.json"
	method: "GET",
	params: {driver_id: driver_id}, // optional params. if not present response will only have array of waiting requests. If present, response will also 									have drives ongoing cab requests and completed requests
	response: 	{
					waiting_requests: [
						{
							id: 2,
							customer_id: 2,
							driver_id: null
							status: "waiting",
							created_at: "2017-12-22 04:07:08 UTC"
							updated_At: "2017-12-22 04:07:08 UTC"
						}
					],
					ongoing_requests: [
						{
							id: 1,
							customer_id: 1,
							driver_id: {driver_id}
							status: "ongoing",
							created_at: "2017-12-22 04:07:08 UTC"
							updated_At: "2017-12-22 04:07:08 UTC"	
						}
					],
					complete_requests: [
						{
							id: 3,
							customer_id: 3,
							driver_id: {driver_id}
							status: "complete",
							created_at: "2017-12-22 04:07:08 UTC"
							updated_At: "2017-12-22 04:07:08 UTC"	
						}
					]
				}
				status: 200 OK
	```		

* Create cab request // Customer Facing

	```
	path: "/api/one/cab_requests"			
	method: "POST",
	params: {customer_id: customer_id} // required params, if not present server will send status 500 response
	resonpse: 	{message: created, cab_request_id: @cab_request.id}, status: 200 OK if created succesfully 
				{message: failed, reason: resoan_for_failure}, status: 500 if failed to create cab request
				status: 200 OK
	
	```
	
* Select cab request // Driver Facing	


	```
	path: "api/one/cab_request/{:id}/process_request"
	method: "POST",
	params: {driver_id: driver_id}, // required_params, if not present server will send error message
	response: 	{			
					message: selected // if cab request is allocated to driver if he is free and given request is still waiting. Else error message will be sent
				}
				status: 200 OK

				{			
					message: failed, reason: "already serving one cab request" // if driver is not available because he has an ongoing ride\request is 
				}
				status: 500 OK

				{			
					message: failed, reason: "“request no longer available" // if cab request is not available because it has been picked by other driver
				}
				status: 500 OK
	```

