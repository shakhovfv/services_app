class AddLocalityRefToLocalities < ActiveRecord::Migration[6.0]
  def change
    add_reference :localities, :locality, null: true, foreign_key: true
  end
end
