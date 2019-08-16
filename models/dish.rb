class Dish < ActiveRecord::Base
  validates :name, presence: true
  validates :number, presence: true, uniqueness: true
  validates :cuisine, presence: true

  has_many :ingredients
end
