class AddLatLngIndexToShelters < ActiveRecord::Migration[5.0]
  def change
    add_index :shelters, [:lat, :lng], unique: true
  end
end
