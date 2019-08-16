class User < ActiveRecord::Base
  validates :number, presence: true, uniqueness: true
  validates :vegetarian, presence: true

  has_many :user_ingredients
end
