class AddTeamToDrivers < ActiveRecord::Migration[8.1]
  def change
    add_column :drivers, :team, :string
  end
end
