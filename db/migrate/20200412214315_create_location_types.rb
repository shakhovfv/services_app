class CreateLocationTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :location_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
