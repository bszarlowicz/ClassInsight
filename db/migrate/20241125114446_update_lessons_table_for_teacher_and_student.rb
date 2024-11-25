class UpdateLessonsTableForTeacherAndStudent < ActiveRecord::Migration[7.1]
  def change
    remove_reference :lessons, :user, foreign_key: true
    add_reference :lessons, :teacher, null: false, foreign_key: { to_table: :users }
    add_reference :lessons, :student, null: false, foreign_key: { to_table: :users }
  end
end
