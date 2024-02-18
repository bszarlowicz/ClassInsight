class CreateLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.string :dayOfWeek
      t.time :hour

      t.timestamps
    end
  end
end
