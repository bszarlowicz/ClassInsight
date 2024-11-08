class AddOccurrencesArrayToLesson < ActiveRecord::Migration[7.1]
  def change
    add_column :lessons, :occurrences, :json
  end
end
