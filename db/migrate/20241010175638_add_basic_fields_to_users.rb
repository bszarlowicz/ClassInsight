class AddBasicFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :role_mask, :string
    add_column :users, :disabled, :boolean, default: false
    add_index :users, :role_mask
  end
end
