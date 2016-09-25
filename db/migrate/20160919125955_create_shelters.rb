class CreateShelters < ActiveRecord::Migration[5.0]
  def change
    create_table :shelters do |t|
      t.float :lat, null: false
      t.float :lng, null: false
      t.string :name, null: false
      t.string :address, null: false
      t.integer :earthquake_hazard, null: false
      t.integer :tsunami_hazard, null: false
      t.integer :wind_and_flood_damage, null: false
      t.integer :volcanic_hazard, null: false
    end
  end
end
