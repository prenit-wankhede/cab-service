class AddLatitudeAndLongitudeToCabRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :cab_requests, :latitude, :float
    add_column :cab_requests, :longitude, :float
  end
end
