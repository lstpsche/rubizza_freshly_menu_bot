class CreateUserIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :user_ingredients do |t|
      t.references :user, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.integer :score, null: false, default: 0

      t.timestamps
    end
  end
end
