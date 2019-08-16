class Ingredient < ActiveRecord::Base
  validates :name, presence: true

  has_many :dishes
  has_many :user_ingredients
end
