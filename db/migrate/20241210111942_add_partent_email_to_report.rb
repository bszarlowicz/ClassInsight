class AddPartentEmailToReport < ActiveRecord::Migration[7.1]
  def change
    add_column :reports, :parent_email, :string
  end
end
