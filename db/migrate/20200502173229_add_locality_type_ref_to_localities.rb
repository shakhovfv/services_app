class AddLocalityTypeRefToLocalities < ActiveRecord::Migration[6.0]
  def change
    add_reference :localities, :locality_type, null: false, foreign_key: true
  end
end
