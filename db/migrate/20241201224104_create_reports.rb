class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.string :main_school_subject
      t.integer :level
      t.integer :grade
      t.integer :school_rank

      t.timestamps
    end
  end
end
