class AddFieldsToDishes < ActiveRecord::Migration[5.2]
  def change
    add_column :dishes, :number, :integer, null: false, unique: true
    add_column :dishes, :cuisine, :string, null: false
  end
end
