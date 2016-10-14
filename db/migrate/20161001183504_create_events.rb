class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.date :date_start, null: false
      t.date :date_end
      t.boolean :last_day_of_month, default: false
      t.integer :repeat, null: false, default: 0
      t.references :user, null: false

      t.timestamps null: false
    end
  end
end
