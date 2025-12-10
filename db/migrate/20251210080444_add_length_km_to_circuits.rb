class AddLengthKmToCircuits < ActiveRecord::Migration[8.1]
  def change
    add_column :circuits, :length_km, :decimal
  end
end
