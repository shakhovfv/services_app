class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :name, null: false
      t.jsonb :buildings

      t.timestamps
    end
  end
end
