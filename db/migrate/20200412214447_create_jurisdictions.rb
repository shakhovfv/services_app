class CreateJurisdictions < ActiveRecord::Migration[6.0]
  def change
    create_table :jurisdictions do |t|
      t.integer :sector, null: false
      t.string :address
      t.string :phone
      t.jsonb :reception_of_citizens
      t.jsonb :work_time
      t.string :email
      t.string :judge_fio

      t.timestamps
    end
  end
end
