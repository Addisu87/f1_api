class CreateCircuits < ActiveRecord::Migration[8.1]
  def change
    create_table :circuits do |t|
      t.string :name
      t.string :location
      t.decimal :length_km

      t.timestamps
    end
  end
end
