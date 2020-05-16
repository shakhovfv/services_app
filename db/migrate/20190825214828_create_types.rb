class CreateTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :types, id: false, primary_key: :index do |t|
      t.string :name
      t.string :index

      t.timestamps
    end
  end
end
