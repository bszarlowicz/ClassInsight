class RenameDaysOfWeekInLessons < ActiveRecord::Migration[7.1]
  def change
    rename_column :lessons, :daysOfWeek, :days_of_week
  end
end
