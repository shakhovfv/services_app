class AddLocalityRefToAddresses < ActiveRecord::Migration[6.0]
  def change
    add_reference :addresses, :locality, null: false, foreign_key: true
  end
end
