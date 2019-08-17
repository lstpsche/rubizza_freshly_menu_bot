class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :dish

  def like(user_num:)
    update(rating: 1)
    user = User.find_by(number: user_num)
    binding.pry
    dish.dish_ingredients.each do |dish_ingr|
      u_i = UserIngredient.find_by(user: user, ingredient: dish_ingr.ingredient)
      if u_i
        u_i.update(score: u_i.score + 1)
      else
        UserIngredient.create(user: user, ingredient: dish_ingr.ingredient, score: 1)
      end
    end
    binding.pry
  end

  def dislike(user_num:)
    update(rating: -1)
    user = User.find_by(number: user_num)
    dish.dish_ingredients.each do |dish_ingr|
      u_i = UserIngredient.find_by(user: user, ingredient: dish_ingr.ingredient)
      if u_i
        u_i.update(score: u_i.score - 1)
      else
        UserIngredient.create(user: user, ingredient: dish_ingr.ingredient, score: 1)
      end
    end
  end
end
