class AddLocalityRefToDistrict < ActiveRecord::Migration[6.0]
  def change
    add_reference :districts, :locality, null: true, foreign_key: true
  end
end
