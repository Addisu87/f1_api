class CreateLapTimes < ActiveRecord::Migration[8.1]
  def change
    create_table :lap_times do |t|
      t.references :driver, null: false, foreign_key: true
      t.references :circuit, null: false, foreign_key: true
      t.integer :lap_number
      t.float :time

      t.timestamps
    end
  end
end
