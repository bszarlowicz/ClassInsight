class ModifyLessonModelFields < ActiveRecord::Migration[7.1]
  def change
    remove_column :lessons, :dayOfWeek, :string
    add_column :lessons, :daysOfWeek, :json
    add_column :lessons, :year, :integer
    add_reference :lessons, :user, foreign_key: true
  end
end
