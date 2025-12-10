class CreateLapTimes < ActiveRecord::Migration[8.1]
  def change
    create_table :lap_times do |t|
      t.integer :driver_id
      t.integer :circuit_id
      t.integer :time_ms
      t.integer :lap_number

      t.timestamps
    end
  end
end
