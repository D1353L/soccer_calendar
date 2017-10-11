class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.datetime :date_time, null: false

      t.timestamps
    end
  end
end
