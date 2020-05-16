class AddLocationTypeRefToAddresses < ActiveRecord::Migration[6.0]
  def change
    add_reference :addresses, :location_type, null: false, foreign_key: true
  end
end
