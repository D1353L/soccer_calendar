class ChangeNullForNameMatches < ActiveRecord::Migration[5.1]
  def change
    change_column :matches, :date_time, :datetime, null: true
  end
end
