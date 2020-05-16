class AddSubjectToCourt < ActiveRecord::Migration[6.0]
  def change
    add_reference :courts, :subject, null: false, foreign_key: true
  end
end
