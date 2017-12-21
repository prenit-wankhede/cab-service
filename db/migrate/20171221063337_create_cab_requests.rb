class CreateCabRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :cab_requests do |t|
      t.integer :driver_id
      t.integer :customer_id
      t.string :status
      t.datetime :finished_at

      t.timestamps
    end
  end
end
