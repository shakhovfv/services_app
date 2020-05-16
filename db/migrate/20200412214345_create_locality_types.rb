class CreateLocalityTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :locality_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
