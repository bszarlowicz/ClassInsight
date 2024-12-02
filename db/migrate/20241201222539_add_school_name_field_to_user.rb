class AddSchoolNameFieldToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :school_name, :string
  end
end
