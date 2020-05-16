class AddFieldsToJurisdictions < ActiveRecord::Migration[6.0]
  def change
    add_column :jurisdictions, :site, :string
    add_column :jurisdictions, :index, :string
  end
end
