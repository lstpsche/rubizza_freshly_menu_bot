class Dish < ActiveRecord::Base
  validates :number, presence: true, uniqueness: true

  has_many :ingredients
end
