class Dish < ActiveRecord::Base
  validates :number, presence: true, uniqueness: true

  has_many :ingredients
  has_many :dish_ingredients
  has_many :orders

  def rating
    ratings = orders.pluck(:rating)
    ratings.inject(0.0) { |sum, el| sum + el } / ratings.size
  end
end
