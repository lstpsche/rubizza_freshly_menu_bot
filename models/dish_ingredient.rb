class DishIngredient < ActiveRecord::Base
  belongs_to :dish
  belongs_to :ingredient
end
