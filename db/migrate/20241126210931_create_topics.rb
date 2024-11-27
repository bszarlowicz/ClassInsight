class CreateTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :topics do |t|
      t.string :title
      t.date :date
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
