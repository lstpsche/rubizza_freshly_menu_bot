class User < ActiveRecord::Base
  validates :number, presence: true, uniqueness: true
  validates :vegetarian, inclusion: { in: [true, false] }
  validates :name, presence: true

  has_many :user_ingredients
  has_many :orders

  def recomended_menu
    ingredients_scores = Ingredient.joins(:user_ingredients).pluck(:name, :score).to_h
    dishes_ingreds_ids = Dish.all.map(&:dish_ingredients).map { |dish_ingreds| dish_ingreds.map(&:ingredient_id) }.map{|id| Ingredient.find(id) }
    ratings = dishes_ingreds_ids.map { |dish| dish.map {|ingred| ingredients_scores[ingred.name] } }.map { |dish| (dish.inject(&:+).to_f / dish.count).round(2) }
    recomended_menu = Dish.all.map.with_index { |dish, index| [dish, ratings[index]] }.sort {|a,b| b[1] <=> a[1]}
  end

  def add_order(dish_num:)
    Order.create(user_id: id, dish: Dish.find_by(number: dish_num))
  end
end
