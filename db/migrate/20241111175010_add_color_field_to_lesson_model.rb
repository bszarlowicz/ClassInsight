class AddColorFieldToLessonModel < ActiveRecord::Migration[7.1]
  def change
    add_column :lessons, :color, :string
  end
end
