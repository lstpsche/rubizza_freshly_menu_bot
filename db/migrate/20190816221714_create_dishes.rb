class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :name, null: false, default: ''
      t.integer :number, null: false, unique: true
      t.string :cuisine, null: false, default: ''

      t.timestamps
    end
  end
end
