class AddLessonDurationFieldToLessonModel < ActiveRecord::Migration[7.1]
  def change
    add_column :lessons, :duration, :integer
  end
end
