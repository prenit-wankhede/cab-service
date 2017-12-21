class AddIsAvailableToUser < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :is_available, :boolean, default: false 
  end
end
