class AddDistrictRefToJurisdiction < ActiveRecord::Migration[6.0]
  def change
    add_reference :jurisdictions, :district, null: true, foreign_key: true
  end
end
